main :: () {
    window_width  :: 1280;
    window_height :: 720;
    title :: "d3d11 example";

    the_window := create_window(window_width, window_height, title);

    feature_levels := D3D_FEATURE_LEVEL.[ .D3D_FEATURE_LEVEL_11_1 ];

    base_device: *ID3D11Device;
    base_device_context: *ID3D11DeviceContext;

    create_device_flags := D3D11_CREATE_DEVICE_FLAGS.D3D11_CREATE_DEVICE_DEBUG | .D3D11_CREATE_DEVICE_BGRA_SUPPORT;

    {
        res := D3D11CreateDevice(null, .D3D_DRIVER_TYPE_HARDWARE, null, create_device_flags, feature_levels.data,
            feature_levels.count, D3D11_SDK_VERSION, *base_device, null, *base_device_context);
        assert(res == S_OK);
    }

    device: *ID3D11Device1;
    {
        res := base_device.QueryInterface(xx base_device, *uid(ID3D11Device1.uuid), cast(**void)*device);
        assert(res == S_OK);
    }

    device_context1: *ID3D11DeviceContext1;
    {
        res := base_device_context.QueryInterface(xx base_device_context, *uid(ID3D11DeviceContext1.uuid), cast(**void)*device_context1);
        assert(res == S_OK);
    }
    device_context := cast(*ID3D11DeviceContext)device_context1;

    dxgi_device: *IDXGIDevice1;
    {
        res := device.QueryInterface(xx device, *uid(IDXGIDevice1.uuid), cast(**void)*dxgi_device);
        assert(res == S_OK);
    }

    dxgi_adapter: *IDXGIAdapter;
    dxgi_device.GetAdapter(cast(*IDXGIDevice)dxgi_device, *dxgi_adapter);
    assert(dxgi_adapter != null);

    dxgi_factory: *IDXGIFactory2;
    dxgi_adapter.GetParent(cast(*IDXGIObject)dxgi_adapter, *uid(IDXGIFactory2.uuid), cast(**void)*dxgi_factory);
    assert(dxgi_factory != null, "no IDXGIFactory2 returned");

    swap_chain_desc := DXGI_SWAP_CHAIN_DESC1.{
        Width  = 0, // use window width
        Height = 0, // use window height
        Format = DXGI_FORMAT_B8G8R8A8_UNORM_SRGB,
        Stereo = FALSE,
        SampleDesc = .{
            Count = 1,
            Quality = 0,
        },
        BufferUsage = DXGI_USAGE_RENDER_TARGET_OUTPUT,
        BufferCount = 2,
        Scaling = .DXGI_SCALING_STRETCH,
        SwapEffect = .DXGI_SWAP_EFFECT_DISCARD,
        AlphaMode = .DXGI_ALPHA_MODE_UNSPECIFIED,
        Flags = 0,
    };

    swap_chain: *IDXGISwapChain1;
    {
        res := dxgi_factory.CreateSwapChainForHwnd(dxgi_factory, cast(*IUnknown)device, the_window, *swap_chain_desc, null, null, *swap_chain);
        assert(res == S_OK);
        assert(swap_chain != null, "CreateSwapChainForHwnd did not create a swap chain!");
    }

    // frame buffer
    frame_buffer: *ID3D11Texture2D;
    {
        res := swap_chain.GetBuffer(cast(*IDXGISwapChain)swap_chain, 0, *uid(ID3D11Texture2D.uuid), cast(**void)*frame_buffer);
        assert(res == S_OK);
        assert(frame_buffer != null);
    }

    // render target view
    frame_buffer_view: *ID3D11RenderTargetView;
    {
        res := device.CreateRenderTargetView(cast(*ID3D11Device)device, cast(*ID3D11Resource)frame_buffer, null, *frame_buffer_view);
        assert(res == S_OK);
        assert(frame_buffer_view != null);
    }

    // depth buffer
    depth_buffer_desc: D3D11_TEXTURE2D_DESC;
    frame_buffer.GetDesc(frame_buffer, *depth_buffer_desc);
    depth_buffer_desc.Format    = .DXGI_FORMAT_D24_UNORM_S8_UINT;
    depth_buffer_desc.BindFlags = .D3D11_BIND_DEPTH_STENCIL;

    depth_buffer: *ID3D11Texture2D;
    {
        res := device.CreateTexture2D(cast(*ID3D11Device)device, *depth_buffer_desc, null, *depth_buffer);
        assert(res == S_OK);
        assert(depth_buffer != null);
    }

    depth_buffer_view: *ID3D11DepthStencilView;
    {
        res := device.CreateDepthStencilView(cast(*ID3D11Device)device, cast(*ID3D11Resource)depth_buffer, null, *depth_buffer_view);
        assert(res == S_OK);
        assert(depth_buffer_view != null);
    }

    // vertex shader
    vs_blob: *ID3DBlob;
    {
        res := D3DCompileFromFile(utf8_to_wide("shaders.hlsl"), null, null, "vs_main", "vs_5_0", 0, 0, *vs_blob, null);
        assert(res == S_OK);
    }

    vertex_shader: *ID3D11VertexShader;
    {
        res := device.CreateVertexShader(cast(*ID3D11Device)device, vs_blob.GetBufferPointer(vs_blob), vs_blob.GetBufferSize(vs_blob), null, *vertex_shader);
        assert(res == S_OK);
    }

    input_element_desc := D3D11_INPUT_ELEMENT_DESC.[ // float3 position, float3 normal, float2 texcoord, float3 color
        .{ "POS", 0, .DXGI_FORMAT_R32G32B32_FLOAT, 0,                             0, .D3D11_INPUT_PER_VERTEX_DATA, 0 },
        .{ "NOR", 0, .DXGI_FORMAT_R32G32B32_FLOAT, 0, D3D11_APPEND_ALIGNED_ELEMENT, .D3D11_INPUT_PER_VERTEX_DATA, 0 },
        .{ "TEX", 0, .DXGI_FORMAT_R32G32_FLOAT,    0, D3D11_APPEND_ALIGNED_ELEMENT, .D3D11_INPUT_PER_VERTEX_DATA, 0 },
        .{ "COL", 0, .DXGI_FORMAT_R32G32B32_FLOAT, 0, D3D11_APPEND_ALIGNED_ELEMENT, .D3D11_INPUT_PER_VERTEX_DATA, 0 },
    ];

    input_layout: *ID3D11InputLayout;
    {
        res := device.CreateInputLayout(cast(*ID3D11Device)device, input_element_desc.data, input_element_desc.count, vs_blob.GetBufferPointer(vs_blob), vs_blob.GetBufferSize(vs_blob), *input_layout);
        assert(res == S_OK);
        assert(input_layout != null);
    }

    // fragment shader

    ps_blob: *ID3DBlob;
    {
        res := D3DCompileFromFile(utf8_to_wide("shaders.hlsl"), null, null, "ps_main", "ps_5_0", 0, 0, *ps_blob, null);
        assert(res == S_OK);
    }
    pixel_shader: *ID3D11PixelShader;
    {
        res := device.CreatePixelShader(cast(*ID3D11Device)device, ps_blob.GetBufferPointer(ps_blob), ps_blob.GetBufferSize(ps_blob), null, *pixel_shader);
        assert(res == S_OK);
    }

    // rasterizer
    rasterizer_desc := D3D11_RASTERIZER_DESC1.{
        FillMode = .D3D11_FILL_SOLID,
        CullMode = .D3D11_CULL_BACK,
    };

    rasterizer_state: *ID3D11RasterizerState1;
    {
        res := device.CreateRasterizerState1(device, *rasterizer_desc, *rasterizer_state);
        assert(res == S_OK);
    }

    // sampler
    sampler_desc := D3D11_SAMPLER_DESC.{
        Filter         = .D3D11_FILTER_MIN_MAG_MIP_POINT,
        AddressU       = .D3D11_TEXTURE_ADDRESS_WRAP,
        AddressV       = .D3D11_TEXTURE_ADDRESS_WRAP,
        AddressW       = .D3D11_TEXTURE_ADDRESS_WRAP,
        ComparisonFunc = .D3D11_COMPARISON_NEVER,
    };

    sampler_state: *ID3D11SamplerState;
    {
        res := device.CreateSamplerState(cast(*ID3D11Device)device, *sampler_desc, *sampler_state);
        assert(res == S_OK);
    }

    // depth stencil state
    depth_stencil_desc := D3D11_DEPTH_STENCIL_DESC.{
        DepthEnable    = TRUE,
        DepthWriteMask = .D3D11_DEPTH_WRITE_MASK_ALL,
        DepthFunc      = .D3D11_COMPARISON_LESS,
    };

    depth_stencil_state: *ID3D11DepthStencilState;
    {
        res := device.CreateDepthStencilState(xx device, *depth_stencil_desc, *depth_stencil_state);
        assert(res == S_OK);
    }

    // constant buffer
    Constants :: struct {
        Transform: Matrix4;
        Projection: Matrix4;
        LightVector: Vector3;
    };

    constant_buffer_desc := D3D11_BUFFER_DESC.{
        ByteWidth      = #run next_multiple_of(16, size_of(Constants)),
        Usage          = D3D11_USAGE_DYNAMIC,
        BindFlags      = D3D11_BIND_CONSTANT_BUFFER,
        CPUAccessFlags = D3D11_CPU_ACCESS_WRITE,
    };

    constant_buffer: *ID3D11Buffer;
    {
        res := device.CreateBuffer(xx device, *constant_buffer_desc, null, *constant_buffer);
        assert(res == S_OK);
        assert(constant_buffer != null);
    }

    // vertex buffer
    vertex_buffer_desc := D3D11_BUFFER_DESC.{
        ByteWidth = size_of(type_of(VertexData)),
        Usage     = .D3D11_USAGE_IMMUTABLE,
        BindFlags = .D3D11_BIND_VERTEX_BUFFER,
    };

    vertex_data: D3D11_SUBRESOURCE_DATA;
    vertex_data.pSysMem = VertexData.data;

    vertex_buffer: *ID3D11Buffer;
    {
        res := device.CreateBuffer(xx device, *vertex_buffer_desc, *vertex_data, *vertex_buffer);
        assert(res == S_OK);
        assert(vertex_buffer != null);
    }

    // index buffer
    indexBufferDesc := D3D11_BUFFER_DESC.{
        ByteWidth = size_of(type_of(IndexData)),
        Usage     = .D3D11_USAGE_IMMUTABLE,
        BindFlags = .D3D11_BIND_INDEX_BUFFER,
    };

    indexData: D3D11_SUBRESOURCE_DATA;
    indexData.pSysMem = IndexData.data;

    indexBuffer: *ID3D11Buffer;
    {
        res := device.CreateBuffer(xx device, *indexBufferDesc, *indexData, *indexBuffer);
        assert(res == S_OK);
        assert(indexBuffer != null);
    }

    // texture
    textureDesc := D3D11_TEXTURE2D_DESC.{
        Width              = TEXTURE_WIDTH,  // in data.h
        Height             = TEXTURE_HEIGHT, // in data.h
        MipLevels          = 1,
        ArraySize          = 1,
        Format             = DXGI_FORMAT_R8G8B8A8_UNORM_SRGB,
        SampleDesc.Count   = 1,
        Usage              = D3D11_USAGE_IMMUTABLE,
        BindFlags          = D3D11_BIND_SHADER_RESOURCE,
    };

    textureData: D3D11_SUBRESOURCE_DATA;
    textureData.pSysMem            = TextureData.data;
    textureData.SysMemPitch        = TEXTURE_WIDTH * 4; // 4 bytes per pixel

    texture: *ID3D11Texture2D;
    {
        res := device.CreateTexture2D(xx device, *textureDesc, *textureData, *texture);
        assert(res == S_OK);
        assert(texture != null);
    }

    textureView: *ID3D11ShaderResourceView;
    {
        res := device.CreateShaderResourceView(xx device, xx texture, null, *textureView);
        assert(res == S_OK);
        assert(textureView != null);
    }

    // setup

    w := cast(float)depth_buffer_desc.Width;  // width
    h := cast(float)depth_buffer_desc.Height; // height
    n :float = 1000;                                    // near
    f :float = 1000000;                                 // far

    modelRotation    := Vector3.{ 0, 0, 0 };
    modelScale       := Vector3.{ 400.0, 400.0, 400.0 };
    modelTranslation := Vector3.{ 0.0, 0.0, 1500.0 };

    // main loop
    elapsed_time: float64;
    last_time: float64;
    dt: float;
    quit := false;
    while !quit {
        update_window_events();
        for events_this_frame {
            if it.type == {
                case .QUIT;
                    quit = true;
            }
        }

        rotateX: Matrix4;
        rotateY: Matrix4;
        rotateZ: Matrix4;
        scale: Matrix4;
        translate: Matrix4;

        now := get_time();
        if last_time dt = cast(float) (now - last_time);
        last_time = now;
        
        elapsed_time += dt;

        // UPDATE
        rotateX   = make_matrix4(1, 0, 0, 0, 0, cos(modelRotation.x), -sin(modelRotation.x), 0, 0, sin(modelRotation.x), cos(modelRotation.x), 0, 0, 0, 0, 1 );
        rotateY   = make_matrix4(cos(modelRotation.y), 0, sin(modelRotation.y), 0, 0, 1, 0, 0, -sin(modelRotation.y), 0, cos(modelRotation.y), 0, 0, 0, 0, 1 );
        rotateZ   = make_matrix4(cos(modelRotation.z), -sin(modelRotation.z), 0, 0, sin(modelRotation.z), cos(modelRotation.z), 0, 0, 0, 0, 1, 0, 0, 0, 0, 1 );
        scale     = make_matrix4(modelScale.x, 0, 0, 0, 0, modelScale.y, 0, 0, 0, 0, modelScale.z, 0, 0, 0, 0, 1 );
        translate = make_matrix4(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, modelTranslation.x, modelTranslation.y, modelTranslation.z, 1 );

        modelRotation.x += 0.005;
        modelRotation.y += 0.009;
        modelRotation.z += 0.001;
        // END UPDATE

        reset_temporary_storage();

        // DRAW

        mappedSubresource: D3D11_MAPPED_SUBRESOURCE;
        {
            device_context.Map(xx device_context, xx constant_buffer, 0, .D3D11_MAP_WRITE_DISCARD, 0, *mappedSubresource);

            constants := cast(*Constants)mappedSubresource.pData;
            constants.Transform   = rotateX * rotateY * rotateZ * scale * translate;
            constants.Projection  = make_matrix4(2 * n / w, 0, 0, 0, 0, 2 * n / h, 0, 0, 0, 0, f / (f - n), 1, 0, 0, n * f / (n - f), 0 );
            constants.LightVector = .{ 1.0, -1.0, 1.0 };

            device_context.Unmap(xx device_context, xx constant_buffer, 0);
        }

        ///////////////////////////////////////////////////////////////////////////////////////////

        backgroundColor: [4]float = .[ 0.025, 0.025, 0.025, 1.0];

        stride:u32 = 11 * 4; // vertex size (11 floats: float3 position, float3 normal, float2 texcoord, float3 color)
        offset:u32 = 0;

        viewport: D3D11_VIEWPORT;
        viewport.TopLeftX = 0;
        viewport.TopLeftY = 0;
        viewport.Width = w;
        viewport.Height = h;
        viewport.MinDepth = 0;
        viewport.MaxDepth = 1;

        ///////////////////////////////////////////////////////////////////////////////////////////

        device_context.ClearRenderTargetView(device_context, frame_buffer_view, backgroundColor);
        device_context.ClearDepthStencilView(device_context, depth_buffer_view, cast(u32)D3D11_CLEAR_DEPTH, 1.0, 0);

        device_context.IASetPrimitiveTopology(device_context, .D3D11_PRIMITIVE_TOPOLOGY_TRIANGLELIST);
        device_context.IASetInputLayout(device_context, input_layout);
        device_context.IASetVertexBuffers(device_context, 0, 1, *vertex_buffer, *stride, *offset);
        device_context.IASetIndexBuffer(device_context, indexBuffer, .DXGI_FORMAT_R32_UINT, 0);

        device_context.VSSetShader(device_context, vertex_shader, null, 0);
        device_context.VSSetConstantBuffers(device_context, 0, 1, *constant_buffer);

        device_context.RSSetViewports(device_context, 1, *viewport);
        device_context.RSSetState(device_context, xx rasterizer_state);

        device_context.PSSetShader(device_context, pixel_shader, null, 0);
        device_context.PSSetShaderResources(device_context, 0, 1, *textureView);
        device_context.PSSetSamplers(device_context, 0, 1, *sampler_state);

        device_context.OMSetRenderTargets(device_context, 1, *frame_buffer_view, depth_buffer_view);
        device_context.OMSetDepthStencilState(device_context, depth_stencil_state, 0);
        device_context.OMSetBlendState(device_context, null, cast([4]float)null, 0xffffffff); // use default blend mode (i.e. disable)

        ///////////////////////////////////////////////////////////////////////////////////////////

        device_context.DrawIndexed(device_context, IndexData.count, 0, 0);

        ///////////////////////////////////////////////////////////////////////////////////////////

        swap_chain.Present(cast(*IDXGISwapChain)swap_chain, 1, 0);

        // END DRAW
    }
}

#scope_file

next_multiple_of :: (N: int, X: int) -> int {
    // X is the number you want to round up to the nearest multiple N
    return ((N - 1) | (X - 1)) + 1;
}

#import "d3d11";
#import "Windows_Utf8";
#import "dxgi";
#import "D3dcompiler";
#import "Window_Creation";
#import "Input";
#import "Basic";
#import "Windows";
#import "Math";

#load "d3d11_1.jai"; // for 11_1 features
#load "data.jai";    // model data

