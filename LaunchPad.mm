#import <objc/runtime.h>
#import <substrate.h>
@import Foundation;

@class SBFloatingDockController;
static BOOL hook_isFloatingDockSupported(Class self, SEL _cmd) {
	return YES;
}

@class SBFloatingDockDefaults;
static BOOL hook_appLibraryEnabled(SBFloatingDockDefaults *self, SEL _cmd) {
	return YES;
}
static void (* orig_setAppLibraryEnabled) (SBFloatingDockDefaults *self, SEL _cmd, BOOL enabled);
static void hook_setAppLibraryEnabled(SBFloatingDockDefaults *self, SEL _cmd, BOOL enabled) {
	orig_setAppLibraryEnabled(self, _cmd, YES);
}

static BOOL hook_recentsEnabled(SBFloatingDockDefaults *self, SEL _cmd) {
	return NO;
}
static void (* orig_setRecentsEnabled) (SBFloatingDockDefaults *self, SEL _cmd, BOOL enabled);
static void hook_setRecentsEnabled(SBFloatingDockDefaults *self, SEL _cmd, BOOL enabled) {
	orig_setRecentsEnabled(self, _cmd, NO);
}

@class SBDeckSwitcherModifier;
static BOOL hook_shouldConfigureInAppDockHiddenAssertion(SBFloatingDockDefaults *self, SEL _cmd) {
	return YES;
}

@class SBFloatingDockBehaviorAssertion;
static BOOL hook_gesturePossible(SBFloatingDockBehaviorAssertion *self, SEL _cmd) {
	return NO;
}

static void __attribute__((constructor)) ctor () {
	MSHookMessageEx(object_getClass(objc_getClass("SBFloatingDockController")), @selector(isFloatingDockSupported), (IMP)&hook_isFloatingDockSupported, NULL);
	id floatingDockDefaults = objc_getClass("SBFloatingDockDefaults");
	MSHookMessageEx(floatingDockDefaults, @selector(appLibraryEnabled), (IMP) &hook_appLibraryEnabled, NULL);
	MSHookMessageEx(floatingDockDefaults, @selector(setAppLibraryEnabled:), (IMP) &hook_setAppLibraryEnabled, (IMP *) &orig_setAppLibraryEnabled);
	MSHookMessageEx(floatingDockDefaults, @selector(recentsEnabled), (IMP) &hook_recentsEnabled, NULL);
	MSHookMessageEx(floatingDockDefaults, @selector(setRecentsEnabled:), (IMP) &hook_setRecentsEnabled, (IMP *) &orig_setRecentsEnabled);
	MSHookMessageEx(objc_getClass("SBDeckSwitcherModifier"), @selector(shouldConfigureInAppDockHiddenAssertion), (IMP) &hook_shouldConfigureInAppDockHiddenAssertion, NULL);
	MSHookMessageEx(objc_getClass("SBFloatingDockBehaviorAssertion"), @selector(gesturePossible), (IMP) &hook_gesturePossible, NULL);
}