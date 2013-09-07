package com.aljoschability.eclipse.ecodito.diagram.features

import com.aljoschability.eclipse.core.graphiti.features.CoreAddConnectionFeature
import com.aljoschability.eclipse.core.graphiti.features.CoreCreateConnectionFeature
import com.aljoschability.eclipse.ecodito.diagram.util.EClassInheritanceExtensions
import org.eclipse.emf.ecore.EcorePackage
import org.eclipse.graphiti.features.IFeatureProvider
import org.eclipse.graphiti.features.context.IAddConnectionContext
import org.eclipse.graphiti.features.context.IAddContext
import org.eclipse.graphiti.features.context.ICreateConnectionContext
import com.aljoschability.eclipse.core.graphiti.services.AddService

class EClassInheritanceCreateFeature extends CoreCreateConnectionFeature {
	extension EClassInheritanceExtensions = EClassInheritanceExtensions::INSTANCE

	new(IFeatureProvider fp) {
		super(fp)

		name = "Inheritance"
		description = "Create Inheritance"
		imageId = identifier
		largeImageId = identifier
	}

	override canStartConnection(ICreateConnectionContext context) {
		context.sourceEClass != null
	}

	override canCreate(ICreateConnectionContext context) {
		context.sourceEClass != null && context.targetEClass != null
	}

	override createElement(ICreateConnectionContext context) {
		context.sourceEClass.ESuperTypes += context.targetEClass

		return EcorePackage.Literals::ECLASS__ESUPER_TYPES
	}
}

class EClassInheritanceAddFeature extends CoreAddConnectionFeature {
	extension AddService = AddService::INSTANCE
	extension EClassInheritanceExtensions = EClassInheritanceExtensions::INSTANCE

	new(IFeatureProvider fp) {
		super(fp)
	}

	override add(IAddContext context) {
		diagram.addFreeFormConnection [
			start = context.sourceAnchor
			end = context.targetAnchor
			link = context.newObject
			addPolyline[
				//style = diagram.connectionStyle
			]
		]
	}

	override canAdd(IAddContext context) {
		if (context instanceof IAddConnectionContext) {
			context.newObject == EcorePackage.Literals::ECLASS__ESUPER_TYPES
		} else {
			false
		}
	}
}
