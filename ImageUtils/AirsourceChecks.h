// Copyright (c) Airsource Ltd. 2010.
// 
// Airsource hereby grants to the user a worldwide, irrevocable,
// royalty-free, non-exclusive license to use this pre-existing
// intellectual property component for their own business purposes,
// limited in extent to that which is needed for the user to exploit work
// results completed by Airsource.
//
// If you have received this component apart from work produced by
// Airsource you are not authorised to use this component in your
// software. Please contact Airsource on consulting@airsource.co.uk in
// order to discuss your intended use.
//
// Any unauthorised copying of this file constitutes an infringement
// of copyright. All rights reserved.

// If you don't #include this, it all breaks in mysterious ways.
#include <Availability.h>

#define Airsource_GCC_gt(major,minor) (__GNUC__ > major || (__GNUC__ == major && __GNUC_MINOR__ > minor))
#define Airsource_GCC(major,minor)    (__GNUC__ > major || (__GNUC__ == major && __GNUC_MINOR__ >= minor))
#define Airsource_GCC_lt(major,minor) (__GNUC__ < major || (__GNUC__ == major && __GNUC_MINOR__ < minor))

// True iff the specified SDK is known, and the minimum iPhone OS version targeted
// is greater than or equal to the specified version. If true, it indicates that support
// is not being retained below the specified version. If false, it indicates 
// that support is definitely being retained below the specified version.
#define Airsource_iPhoneOS_Min(v) (defined(__IPHONE_ ## v) && __IPHONE_ ## v <= __IPHONE_OS_VERSION_MIN_REQUIRED)

// True iff compiling under iOS SDK of version v or newer.
// This is designed to allow developers to use new (e.g. beta) APIs without breaking builds for everyone else.
#define Airsource_iPhoneOS_SDK(v) (defined(__IPHONE_ ## v) && __IPHONE_ ## v <= __IPHONE_OS_VERSION_MAX_ALLOWED)

// True iff compiling under iOS SDK of version v or older.
// This is designed to work around bugs in old SDKs (e.g. non-weak symbols which should be weak)
#define Airsource_iPhoneOS_SDK_le(v) (defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && (!defined(__IPHONE_ ## v) || __IPHONE_ ## v >= __IPHONE_OS_VERSION_MAX_ALLOWED))

#define Airsource_MacOSX_Min(v) (defined( __MAC_ ## v) && __MAC_ ## v <= __MAC_OS_VERSION_MIN_REQUIRED)
#define Airsource_MacOSX_SDK_lt(v) (!defined( __MAC_ ## v) || __MAC_ ## v > __MAC_OS_X_VERSION_MAX_ALLOWED)

#ifdef __IPHONE_OS_VERSION_MIN_REQUIRED
	#if !Airsource_iPhoneOS_Min(3_0) && Airsource_GCC_gt(4,0)
		#warning "Compiling for <3.0 with GCC >4.0. This is known to break __floatundidf and some C++ stuff."
	#endif

	#if (Airsource_iPhoneOS_Min(3_0) && !Airsource_iPhoneOS_SDK(4_0)) && Airsource_GCC_lt(4,2)
		#warning "iPhone OS 3.x, but compiling with GCC < 4.2. You really ought to compile with GCC 4.2."
	#endif
#else
	#warning "__IPHONE_OS_VERSION_MIN_REQUIRED not defined. This might not be an error if we ever write Mac OS apps."
#endif

// Compile-time checks. They may not work in C++.
#define AS_CAssert(x) ((void)sizeof(char[__builtin_choose_expr((x),1,-1)]))
#define AS_CAssertConstant(x) ((void)__builtin_choose_expr((x),1,2))
#define AS_IsArray(x) __builtin_types_compatible_p(__typeof(x),__typeof((x)[0])[])
#define AS_ArraySize(x) (sizeof(char[__builtin_choose_expr(AS_IsArray(x),sizeof(x),-1)]))
#define AS_CountOf(x) (sizeof(char[__builtin_choose_expr(AS_IsArray(x),sizeof(x)/sizeof((x)[0]),-1)]))

// Objective-C "dynamic cast"
#define ASDynamicCast(C, o) ({ __typeof__(o) ASDynamicCast__o = (o); [ASDynamicCast__o isKindOfClass:[C class]] ? (C*)ASDynamicCast__o : nil; })

#define ASDynamicCastClassObject(Co, o) ({ __typeof__(o) ASDynamicCast__o = (o); [ASDynamicCast__o isKindOfClass:Co] ? (id)ASDynamicCast__o : nil; })

// Objective-C "static cast" with assert().
#define ASAssertStaticCast(C, o) ({ __typeof__(o) ASAssertStaticCast__o = (o); assert([ASAssertStaticCast__o isKindOfClass:[C class]]); (C*)ASAssertStaticCast__o; })
#define ASAssertStaticCastOrNil(C, o) ({ __typeof__(o) ASAssertStaticCastOrNil__o = (o); assert(!ASAssertStaticCastOrNil__o || [ASAssertStaticCastOrNil__o isKindOfClass:[C class]]); (C*)ASAssertStaticCastOrNil__o; })

// Autorelease (and make collectable?) a CF type. Returns a pointer of the original type.
//#define ASCFAutorelease(o) ({__typeof__(o) ASCFAutorelease_o = (o); (__typeof__(o))[NSMakeCollectable(ASCFAutorelease_o) autorelease];})
#define ASCFAutorelease(o) ((__typeof__(o))[(id)(o) autorelease])

/**
** Walks up (or down) a list/tree/etc of objects, looking for one of class C.
** The intended use cases are something like this:
**   Return the containing view that's a UITableViewCell:
**     ASFirstObjectOfClass(UITableViewCell, button, superview)
**   Return the containing VC that's a MyCustomViewController:
**     ASFirstObjectOfClass(MyCustomViewController, button, parentViewController)
**   Return the first item in a linked list of type MyClass:
**     ASFirstObjectOfClass(MyClass, list, next)
**
** LIMITATIONS:
**   It uses __typeof__([(o) nextMethodName]) to determine the common type of items in the tree.
**   If you have overridden e.g. parentViewController to return a subtype, it will probably fail.
** WORKAROUND:
**   Use ASFirstObjectOfClass(CustomViewController, (UIViewController*)self, parentViewController)
*/
#define ASFirstObjectOfClass(C, o, nextMethodName) ({ \
	C * ASFirstObjectOfClass_ret = nil; \
	for ( \
		__typeof__([(o) nextMethodName]) ASFirstObjectOfClass_o = (o); \
		ASFirstObjectOfClass_o; \
		ASFirstObjectOfClass_o = [ASFirstObjectOfClass_o nextMethodName] \
	) \
	{ \
		ASFirstObjectOfClass_ret = ASDynamicCast(C, ASFirstObjectOfClass_o); \
		if (ASFirstObjectOfClass_ret) \
		{ \
			break; \
		} \
	} \
	ASFirstObjectOfClass_ret; \
})

#define ASFirstObjectOfClassOfClassObject(Co, o, nextMethodName) ({ \
	id ASFirstObjectOfClass_ret = nil; \
	for ( \
		__typeof__([(o) nextMethodName]) ASFirstObjectOfClass_o = (o); \
		ASFirstObjectOfClass_o; \
		ASFirstObjectOfClass_o = [ASFirstObjectOfClass_o nextMethodName] \
	) \
	{ \
		ASFirstObjectOfClass_ret = ASDynamicCastClassObject(Co, ASFirstObjectOfClass_o); \
		if (ASFirstObjectOfClass_ret) \
		{ \
			break; \
		} \
	} \
	ASFirstObjectOfClass_ret; \
})

// UIView self-or-ancestor of a given class (e.g. table cell that this button is in)
#define ASViewOrAncestorOfClass(C, v) ASFirstObjectOfClass(C, v, superview);
