#include <stdio.h>
#include "HsFFI.h"

#ifdef __APPLE__
#include <objc/objc.h>
#include <objc/objc-runtime.h>
#endif

#include <SDL/SDL.h>

#ifdef __GLASGOW_HASKELL__
#include "HSMain_stub.h"
extern void __stginit_HSMain ( void );
#endif

#ifdef __APPLE__
int SDL_main(int argc, char *argv[])
#else
int main(int argc, char *argv[])
#endif
{
    int i;

#ifdef __APPLE__
    void * pool =
      objc_msgSend(objc_lookUpClass("NSAutoreleasePool"), sel_getUid("alloc"));
    objc_msgSend(pool, sel_getUid("init"));
#endif

    hs_init(&argc, &argv);
#ifdef __GLASGOW_HASKELL__
    hs_add_root(__stginit_HSMain);
#endif

    hs_main();

    hs_exit();

#ifdef __APPLE__
    objc_msgSend(pool, sel_getUid("release"));
#endif
    return 0;
}
