package com.aljoschability.eclipse.ecodito.diagram.features

import com.aljoschability.eclipse.core.graphiti.features.CoreCreateFeature
import com.aljoschability.eclipse.ecodito.diagram.util.EAttributeExtensions
import org.eclipse.emf.ecore.EcoreFactory
import org.eclipse.graphiti.features.IFeatureProvider
import org.eclipse.graphiti.features.context.IAddContext
import org.eclipse.graphiti.features.context.ICreateContext
import org.eclipse.graphiti.features.context.ILayoutContext
import org.eclipse.graphiti.features.context.IUpdateContext
import org.eclipse.graphiti.features.impl.AbstractAddFeature
import org.eclipse.graphiti.features.impl.AbstractLayoutFeature
import org.eclipse.graphiti.features.impl.AbstractUpdateFeature
import org.eclipse.graphiti.features.impl.Reason
import org.eclipse.emf.ecore.EClass
import com.aljoschability.eclipse.core.graphiti.services.AddService

class EAttributeCreateFeature extends CoreCreateFeature {
	extension EAttributeExtensions = EAttributeExtensions::INSTANCE

	new(IFeatureProvider fp) {
		super(fp)

		name = "Attribute"
		description = "Create Attribute"
		imageId = identifier
		largeImageId = identifier

		editable = true
	}

	override canCreate(ICreateContext context) {
		return context.EClass != null
	}

	override createElement(ICreateContext context) {
		val element = EcoreFactory::eINSTANCE.createEAttribute
		element.name = context.EClass.nextAttributeName("attribute")

		context.EClass.EStructuralFeatures += element

		return element
	}

	def String nextAttributeName(EClass eClass, String prefix) {
		var index = 1
		var name = prefix + index
		while (eClass.getEStructuralFeature(name) != null) {
			name = prefix + index++
		}
		return name
	}

}

class EAttributeAddFeature extends AbstractAddFeature {
	extension AddService = AddService::INSTANCE
	extension EAttributeExtensions = EAttributeExtensions::INSTANCE

	new(IFeatureProvider fp) {
		super(fp)
	}

	override add(IAddContext context) {
		context.container.addContainerShape [
			link = context.newObject
			newRectangle[
				position = context.position
				size = context.size(150, 20)
				style = diagram.shapeStyle
				newImage[ // attribute symbol
					id = context.EAttribute.symbol
					position = #[2, 2]
					size = #[16, 16]
				]
				newText[ // attribute text
					position = #[20, 0]
					size = #[150, 20]
					style = diagram.textStyle
					value = context.EAttribute.name
				]
			]
		]
	}

	override canAdd(IAddContext context) {
		context.EAttribute != null
	}
}

class EAttributeLayoutFeature extends AbstractLayoutFeature {
	extension EAttributeExtensions = EAttributeExtensions::INSTANCE

	new(IFeatureProvider fp) {
		super(fp)
	}

	override canLayout(ILayoutContext context) {
		context.EAttribute != null
	}

	override layout(ILayoutContext context) {
		false
	}
}

class EAttributeUpdateFeature extends AbstractUpdateFeature {
	new(IFeatureProvider fp) {
		super(fp)
	}

	override canUpdate(IUpdateContext context) {
		false
	}

	override update(IUpdateContext context) {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}

	override updateNeeded(IUpdateContext context) {

		//throw new UnsupportedOperationException("TODO: auto-generated method stub")
		Reason::createFalseReason
	}
}
