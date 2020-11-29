ID3D11Device1 :: struct {
    using vtable: *ID3D11Device1_VTable;
    uuid :: "a04bfb29-08ef-43d6-a49c-a9bdbdcbe686";

}

ID3D11Device1_VTable :: struct {
    using device: ID3D11Device_VTable;

    CreateBlendState1: (this: *ID3D11Device1, pBlendStateDesc: *D3D11_BLEND_DESC1, ppBlendState: *ID3D11BlendState1) -> HRESULT #foreign;
    CreateDeferredContext1: (this: *ID3D11Device1, ContextFlags: u32, ppDeferredContext: *ID3D11DeviceContext1) -> HRESULT #foreign;
    CreateDeviceContextState: (this: *ID3D11Device1, Flags: u32, pFeatureLevels: *D3D_FEATURE_LEVEL, FeatureLevels: u32, SDKVersion: u32, EmulatedInterface: *IID, pChosenFeatureLevel: *D3D_FEATURE_LEVEL, ppContextState: *ID3DDeviceContextState) -> HRESULT #foreign;
    CreateRasterizerState1: (this: *ID3D11Device1, pRasterizerDesc: *D3D11_RASTERIZER_DESC1, ppRasterizerState: **ID3D11RasterizerState1) -> HRESULT #foreign;
    GetImmediateContext1: (this: *ID3D11Device1, ppImmediateContext: *ID3D11DeviceContext1) #foreign;
    OpenSharedResource1: (this: *ID3D11Device1, hResource: HANDLE, returnedInterface: *IID, ppResource: **void) -> HRESULT #foreign;
    OpenSharedResourceByName: (this: *ID3D11Device1, lpName: *u16, dwDesiredAccess: u32, returnedInterface: *IID, ppResource: **void) -> HRESULT #foreign;
}

ID3DDeviceContextState :: struct {
    uuid :: "5c1e0d8a-7c23-48f9-8c59-a92958ceff11";
    using vtable: *ID3DDeviceContextState_VTable;
}

ID3DDeviceContextState_VTable :: struct {
    using device_child: ID3D11DeviceChild_VTable;
}

ID3D11BlendState1 :: struct {
    uuid :: "cc86fabe-da55-401d-85e7-e3c9de2877e9";

    using vtable: *ID3D11BlendState1_VTable;
}

ID3D11BlendState1_VTable :: struct {
    using blend_state: ID3D11BlendState_VTable;
    GetDesc1: (pDesc: *D3D11_BLEND_DESC1) #foreign;
};

D3D11_BLEND_DESC1 :: struct {
    AlphaToCoverageEnable: BOOL;
    IndependentBlendEnable: BOOL;
    RenderTarget: [8]D3D11_RENDER_TARGET_BLEND_DESC1;
}

D3D11_RENDER_TARGET_BLEND_DESC1 :: struct {
    BlendEnable: BOOL;
    LogicOpEnable: BOOL;
    SrcBlend: D3D11_BLEND;
    DestBlend: D3D11_BLEND;
    BlendOp: D3D11_BLEND_OP;
    SrcBlendAlpha: D3D11_BLEND;
    DestBlendAlpha: D3D11_BLEND;
    BlendOpAlpha: D3D11_BLEND_OP;
    LogicOp: D3D11_LOGIC_OP;
    RenderTargetWriteMask: u8;
}

ID3D11DeviceContext1 :: struct {
    uuid :: "bb2c6faa-b5fb-4082-8e6b-388b8cfa90e1";
    using vtable: *ID3D11DeviceContext1_VTable;
}

ID3D11DeviceContext1_VTable :: struct {
    using device_context: ID3D11DeviceContext_VTable;

    CopySubresourceRegion1: (
        pDstResource: *ID3D11Resource,
        DstSubresource: u32,
        DstX: u32,
        DstY: u32,
        DstZ: u32,
        pSrcResource: *ID3D11Resource,
        SrcSubresource: u32,
        pSrcBox: *D3D11_BOX,
        CopyFlags: u32) #foreign; 

    UpdateSubresource1: (
        pDstResource: *ID3D11Resource,
        DstSubresource: u32,	
        pDstBox: *D3D11_BOX,
        pSrcData: *void,
        SrcRowPitch: u32,
        SrcDepthPitch: u32,
        CopyFlags: u32 ) #foreign;

    DiscardResource: (
        pResource: *ID3D11Resource
    ) #foreign;

    DiscardView: (
        pResourceView: *ID3D11View
    ) #foreign;

    VSSetConstantBuffers1: (
        StartSlot: u32,
        NumBuffers: u32,
        ppConstantBuffers: **ID3D11Buffer,
        pFirstConstant: *u32,
        pNumConstants: *u32 ) #foreign;

    HSSetConstantBuffers1: (
        StartSlot: u32,
        NumBuffers: u32,
        ppConstantBuffers: **ID3D11Buffer,
        pFirstConstant: *u32,
        pNumConstants: *u32 ) #foreign;

    DSSetConstantBuffers1: (
        StartSlot: u32,
        NumBuffers: u32,
        ppConstantBuffers: **ID3D11Buffer,
        pFirstConstant: *u32,
        pNumConstants: *u32 ) #foreign;

    GSSetConstantBuffers1: (
        StartSlot: u32,
        NumBuffers: u32,
        ppConstantBuffers: **ID3D11Buffer,
        pFirstConstant: *u32,
        pNumConstants: *u32 ) #foreign;

    PSSetConstantBuffers1: (
        StartSlot: u32,
        NumBuffers: u32,
        ppConstantBuffers: **ID3D11Buffer,
        pFirstConstant: *u32,
        pNumConstants: *u32 ) #foreign;

    CSSetConstantBuffers1: (
        StartSlot: u32,
        NumBuffers: u32,
        ppConstantBuffers: **ID3D11Buffer,
        pFirstConstant: *u32,
        pNumConstants: *u32 ) #foreign;

    VSGetConstantBuffers1: (
        StartSlot: u32,
        NumBuffers: u32,
        ppConstantBuffers: **ID3D11Buffer,
        pFirstConstant: *u32,
        pNumConstants: *u32 ) #foreign;

    HSGetConstantBuffers1: (
        StartSlot: u32,
        NumBuffers: u32,
        ppConstantBuffers: **ID3D11Buffer,
        pFirstConstant: *u32,
        pNumConstants: *u32 ) #foreign;

    DSGetConstantBuffers1: (
        StartSlot: u32,
        NumBuffers: u32,
        ppConstantBuffers: **ID3D11Buffer,
        pFirstConstant: *u32,
        pNumConstants: *u32 ) #foreign;

    GSGetConstantBuffers1: (
        StartSlot: u32,
        NumBuffers: u32,
        ppConstantBuffers: **ID3D11Buffer,
        pFirstConstant: *u32,
        pNumConstants: *u32 ) #foreign;

    PSGetConstantBuffers1: (
        StartSlot: u32,
        NumBuffers: u32,
        ppConstantBuffers: **ID3D11Buffer,
        pFirstConstant: *u32,
        pNumConstants: *u32 ) #foreign;

    CSGetConstantBuffers1: (
        StartSlot: u32,
        NumBuffers: u32,
        ppConstantBuffers: **ID3D11Buffer,
        pFirstConstant: *u32,
        pNumConstants: *u32 ) #foreign;

    SwapDeviceContextState: (
        pState: *ID3DDeviceContextState, 
        ppPreviousState: **ID3DDeviceContextState ) #foreign;

    ClearView: (
        pView: *ID3D11View,
        Color: [4]float,
        pRect: *D3D11_RECT,
        NumRects: u32 ) #foreign;

    DiscardView1 : (
        pResourceView: *ID3D11View,
        pRects: *D3D11_RECT,
        NumRects: u32
    ) #foreign;
}

IDXGISwapChain1 :: struct {
    using vtable : *IDXGISwapChain1_VTable;
    uuid :: "790a45f7-0d42-4876-983a-0a55cfe6f4aa";
}

IDXGISwapChain1_VTable :: struct {
    using swap_chain_vtable : IDXGISwapChain_VTable;

    GetDesc1: (pDesc: *DXGI_SWAP_CHAIN_DESC1) -> HRESULT #foreign;
    GetFullscreenDesc: (pDesc: *DXGI_SWAP_CHAIN_FULLSCREEN_DESC) -> HRESULT #foreign;
    GetHwnd: (pHwnd: *HWND) -> HRESULT #foreign;
    GetCoreWindow: (refiid: REFIID, ppUnk: **void) -> HRESULT #foreign;
    Present1: (SyncInterval: u32, PresentFlags: u32, pPresentParameters: *DXGI_PRESENT_PARAMETERS) -> HRESULT #foreign;
    IsTemporaryMonoSupported: () -> BOOL #foreign;
    GetRestrictToOutput: (ppRestrictToOutput: **IDXGIOutput) -> HRESULT #foreign;
    SetBackgroundColor: (pColor: *DXGI_RGBA) -> HRESULT #foreign;
    GetBackgroundColor: (pColor: *DXGI_RGBA) -> HRESULT #foreign;
    SetRotation: (Rotation: DXGI_MODE_ROTATION ) -> HRESULT #foreign;
    GetRotation: (pRotation: *DXGI_MODE_ROTATION) -> HRESULT #foreign;
}

DXGI_PRESENT_PARAMETERS :: struct {
    DirtyRectsCount: u32;
    pDirtyRects: *RECT;
    pScrollRect: *RECT;
    pScrollOffset: *POINT;
}

DXGI_RGBA :: struct {
    r: float;
    g: float;
    b: float;
    a: float;
}

IDXGIFactory2 :: struct {
    using vtable: *IDXGIFactory2_VTable;
    uuid :: "50c83a1c-e072-4c48-87b0-3630fa36a6d0";
}

IDXGIFactory2_VTable :: struct {
    using factory1: IDXGIFactory1_VTable;

    IsWindowedStereoEnabled: (this: *IDXGIFactory2) -> BOOL #foreign;

    CreateSwapChainForHwnd: (
         this: *IDXGIFactory2,
         pDevice: *IUnknown,
         hWnd: HWND,
         pDesc: *DXGI_SWAP_CHAIN_DESC1,
         pFullscreenDesc: *DXGI_SWAP_CHAIN_FULLSCREEN_DESC,
         pRestrictToOutput: *IDXGIOutput,
         ppSwapChain: **IDXGISwapChain1) -> HRESULT #foreign;

    CreateSwapChainForCoreWindow: (
        this: *IDXGIFactory2,
        pDevice: *IUnknown,
        pWindow: *IUnknown,
        pDesc: *DXGI_SWAP_CHAIN_DESC1,
        pRestrictToOutput: *IDXGIOutput,
        ppSwapChain: **IDXGISwapChain1) -> HRESULT #foreign;

    GetSharedResourceAdapterLuid: (
        this: *IDXGIFactory2,
         hResource: HANDLE,
         pLuid: *LUID) -> HRESULT #foreign;

    RegisterStereoStatusWindow: (
         this: *IDXGIFactory2,
         WindowHandle: HWND,
         wMsg: u32,
         pdwCookie: *DWORD) -> HRESULT #foreign;

     RegisterStereoStatusEvent: (
         this: *IDXGIFactory2,
         hEvent: HANDLE, pdwCookie: *DWORD) -> HRESULT #foreign;

     UnregisterStereoStatus: #type (
         this: *IDXGIFactory2,
         dwCookie: DWORD) #foreign;

     RegisterOcclusionStatusWindow: (
         this: *IDXGIFactory2,
         WindowHandle: HWND,
         wMsg: u32,
         pdwCookie: *DWORD) -> HRESULT #foreign;

     RegisterOcclusionStatusEvent: (
         this: *IDXGIFactory2,
         hEvent: HANDLE,
         pdwCookie: *DWORD) -> HRESULT #foreign;

     UnregisterOcclusionStatus: #type (
         this: *IDXGIFactory2,
         dwCookie: DWORD) #foreign;

     CreateSwapChainForComposition: (
         this: *IDXGIFactory2,
         pDevice: *IUnknown,
         pDesc: *DXGI_SWAP_CHAIN_DESC1,
         pRestrictToOutput: *IDXGIOutput,
         ppSwapChain: **IDXGISwapChain1) -> HRESULT #foreign;
}

DXGI_SWAP_CHAIN_DESC1 :: struct {
    Width: u32;
    Height: u32;
    Format: DXGI_FORMAT;
    Stereo: BOOL;
    SampleDesc: DXGI_SAMPLE_DESC;
    BufferUsage: DXGI_USAGE;
    BufferCount: u32;
    Scaling: DXGI_SCALING;
    SwapEffect: DXGI_SWAP_EFFECT;
    AlphaMode: DXGI_ALPHA_MODE;
    Flags: u32;
}


print_offsets :: ($t: Type) {
    print("Actual offsets from C++\n");
    print(#string END
sizeof(DXGI_SWAP_CHAIN_DESC1): 48
offsetof(DXGI_SWAP_CHAIN_DESC1, Width): 0
offsetof(DXGI_SWAP_CHAIN_DESC1, Height): 4
offsetof(DXGI_SWAP_CHAIN_DESC1, Format): 8
offsetof(DXGI_SWAP_CHAIN_DESC1, Stereo): 12
offsetof(DXGI_SWAP_CHAIN_DESC1, SampleDesc): 16
offsetof(DXGI_SWAP_CHAIN_DESC1, BufferUsage): 24
offsetof(DXGI_SWAP_CHAIN_DESC1, BufferCount): 28
offsetof(DXGI_SWAP_CHAIN_DESC1, Scaling): 32
offsetof(DXGI_SWAP_CHAIN_DESC1, SwapEffect): 36
offsetof(DXGI_SWAP_CHAIN_DESC1, AlphaMode): 40
offsetof(DXGI_SWAP_CHAIN_DESC1, Flags): 44

END);

    print("Offsets in Jai\n");
    for type_info(t).members {
        print("%.%: %\n", t, it.name, it.offset_in_bytes);
    }

    print("size_of(DXGI_SWAP_EFFECT): %\n", size_of(DXGI_SWAP_EFFECT));
}

//#run print_offsets(DXGI_SWAP_CHAIN_DESC1);
//#run check_type_offset(DXGI_SWAP_CHAIN_DESC1, "Scaling", 32);
//#run check_type_offset(DXGI_SWAP_CHAIN_DESC1, "SwapEffect", 36);
//#run check_type_size(DXGI_SWAP_CHAIN_DESC1, 48);



offset_of :: ($T: Type, $member: string) -> s64 {
    #insert #run sprint(BODY, member);
    BODY :: #string DONE
        dummy: T = ---;
        return cast(*void) (*dummy.%) - cast(*void) *dummy;
    DONE
}

check_type_size :: ($t: Type, expected_size: int) {
    sz := size_of(t);
    N := expected_size;
    if sz != N
        assert(false, "error: % was supposed to be %, but we got %", t, N, sz);
}

check_type_offset :: ($t: Type, $field_name: string, expected_offset: int) {
    offset := offset_of(t, field_name);
    if offset != expected_offset
        assert(false, "error: %.% was supposed to be at offset %, but we got %", t, field_name, expected_offset, offset);
}

DXGI_SCALING :: enum u32 {
  DXGI_SCALING_STRETCH;
  DXGI_SCALING_NONE;
  DXGI_SCALING_ASPECT_RATIO_STRETCH;
}

DXGI_ALPHA_MODE :: enum u32 {
  DXGI_ALPHA_MODE_UNSPECIFIED;
  DXGI_ALPHA_MODE_PREMULTIPLIED;
  DXGI_ALPHA_MODE_STRAIGHT;
  DXGI_ALPHA_MODE_IGNORED;
  DXGI_ALPHA_MODE_FORCE_DWORD;
}

DXGI_SWAP_CHAIN_FULLSCREEN_DESC :: struct {
    RefreshRate: DXGI_RATIONAL;
    ScanlineOrdering: DXGI_MODE_SCANLINE_ORDER;
    Scaling: DXGI_MODE_SCALING;
    Windowed: BOOL;
}

D3D11_RASTERIZER_DESC1 :: struct {
    FillMode: D3D11_FILL_MODE;
    CullMode: D3D11_CULL_MODE;
    FrontCounterClockwise: BOOL;
    DepthBias: s32;
    DepthBiasClamp: float;
    SlopeScaledDepthBias: float;
    DepthClipEnable: BOOL;
    ScissorEnable: BOOL;
    MultisampleEnable: BOOL;
    AntialiasedLineEnable: BOOL;
    ForcedSampleCount: u32;
}

ID3D11RasterizerState1 :: struct {
    using vtable: *ID3D11RasterizerState1_VTable;
    uuid :: "1217d7a6-5039-418c-b042-9cbe256afd6e";
}

ID3D11RasterizerState1_VTable :: struct {
    using rasterizer_state: ID3D11RasterizerState_VTable;

    GetDesc1: (pDesc: *D3D11_RASTERIZER_DESC1) #foreign;
}

D3D11_LOGIC_OP :: enum u32 {       // Operation: 
                                   // (s == PS output, d = RTV contents)
    D3D11_LOGIC_OP_CLEAR :: 0;     // 0
    D3D11_LOGIC_OP_SET;            // 1
    D3D11_LOGIC_OP_COPY;           // s
    D3D11_LOGIC_OP_COPY_INVERTED;  // ~s
    D3D11_LOGIC_OP_NOOP;           // d
    D3D11_LOGIC_OP_INVERT;         // ~d
    D3D11_LOGIC_OP_AND;            // s & d
    D3D11_LOGIC_OP_NAND;           // ~(s & d)
    D3D11_LOGIC_OP_OR;             // s | d
    D3D11_LOGIC_OP_NOR;            // ~(s | d)
    D3D11_LOGIC_OP_XOR;            // s ^ d
    D3D11_LOGIC_OP_EQUIV;          // ~(s ^ d)
    D3D11_LOGIC_OP_AND_REVERSE;    // s & ~d
    D3D11_LOGIC_OP_AND_INVERTED;   // ~s & d
    D3D11_LOGIC_OP_OR_REVERSE;     // s | ~d
    D3D11_LOGIC_OP_OR_INVERTED;    // ~s | d
}

FALSE: BOOL: 0;
TRUE: BOOL: cast(BOOL)1;


// ~~~~~~~~~~~
