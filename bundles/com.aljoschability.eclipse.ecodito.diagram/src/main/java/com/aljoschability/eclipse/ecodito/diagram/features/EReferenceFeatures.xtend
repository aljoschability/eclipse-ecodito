package com.aljoschability.eclipse.ecodito.diagram.features

import com.aljoschability.eclipse.core.graphiti.features.CoreCreateConnectionFeature
import com.aljoschability.eclipse.ecodito.diagram.util.EReferenceExtensions
import org.eclipse.emf.ecore.EcorePackage
import org.eclipse.graphiti.features.IFeatureProvider
import org.eclipse.graphiti.features.context.ICreateConnectionContext

class EReferenceCreateFeature extends CoreCreateConnectionFeature {
	extension EReferenceExtensions = EReferenceExtensions::INSTANCE

	new(IFeatureProvider fp) {
		super(fp)

		name = "Reference"
		description = "Create Reference"
		imageId = EcorePackage.Literals::EREFERENCE.name
		largeImageId = EcorePackage.Literals::EREFERENCE.name

		editable = true
	}

	override canCreate(ICreateConnectionContext context) {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}

	override canStartConnection(ICreateConnectionContext context) {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}

	override create(ICreateConnectionContext context) {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}
}
