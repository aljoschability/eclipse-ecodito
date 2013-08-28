package com.aljoschability.eclipse.ecodito.properties;

import org.eclipse.ocl.examples.xtext.console.XtextConsolePlugin;
import org.eclipse.ocl.examples.xtext.essentialocl.utilities.EssentialOCLPlugin;

import com.aljoschability.core.ui.runtime.AbstractActivator;
import com.aljoschability.core.ui.runtime.IActivator;

final class Activator extends AbstractActivator {
	static IActivator INSTANCE;

	def static IActivator get() {
		Activator::INSTANCE
	}

	override protected dispose() {
		Activator::INSTANCE = null
	}

	override protected initialize() {
		Activator::INSTANCE = this

		// prepare injector for OCL editor
		XtextConsolePlugin::getInstance().getInjector(EssentialOCLPlugin::LANGUAGE_ID)
	}
}
