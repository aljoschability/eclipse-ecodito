package com.aljoschability.eclipse.grecoto.ui.properties;

import org.eclipse.ocl.examples.xtext.console.XtextConsolePlugin;
import org.eclipse.ocl.examples.xtext.essentialocl.utilities.EssentialOCLPlugin;

import com.aljoschability.core.ui.runtime.AbstractActivator;
import com.aljoschability.core.ui.runtime.IActivator;

final class Activator extends AbstractActivator {
	static IActivator INSTANCE;

	def static IActivator get() {
		Activator::INSTANCE
	}

	override void dispose() {
		Activator::INSTANCE = null
	}

	override void initialize() {
		Activator::INSTANCE = this

		// prepare injector for OCL editor
		XtextConsolePlugin::getInstance().getInjector(EssentialOCLPlugin::LANGUAGE_ID)
	}
}
