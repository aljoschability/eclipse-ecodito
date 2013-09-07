package com.aljoschability.eclipse.ecodito.diagram.features

import com.aljoschability.eclipse.core.graphiti.features.CoreCreateFeature
import com.aljoschability.eclipse.core.graphiti.services.AddService
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

class EAttributeCreateFeature extends CoreCreateFeature {
	extension EAttributeExtensions = EAttributeExtensions::INSTANCE

	new(IFeatureProvider fp) {
		super(fp)

		name = "Attribute"
		description = "Create Attribute"
		imageId = identifier
		largeImageId = identifier
	}

	override canCreate(ICreateContext context) {
		context.EClass != null
	}

	override createElement(ICreateContext context) {
		val element = EcoreFactory::eINSTANCE.createEAttribute
		element.name = context.EClass.nextEStructuralFeatureName("attribute")

		context.EClass.EStructuralFeatures += element

		return element
	}
}

class EAttributeAddFeature extends AbstractAddFeature {
	extension AddService = AddService::INSTANCE
	extension EAttributeExtensions = EAttributeExtensions::INSTANCE

	new(IFeatureProvider fp) {
		super(fp)
	}

	override canAdd(IAddContext context) {
		context.EAttribute != null
	}

	override add(IAddContext context) {
		context.container.addContainerShape [
			link = context.newObject
			addRectangle [
				position = context.position
				size = context.size(150, 20)
				style = diagram.shapeStyle
				// symbol
				addImage(context.EAttribute.image) [
					position = #[2, 2]
					size = #[16, 16]
				]
				// text
				addText [
					position = #[20, 0]
					size = #[150, 20]
					style = diagram.textStyle
					value = context.EAttribute.name
				]
			]
		]
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
	extension EAttributeExtensions = EAttributeExtensions::INSTANCE

	new(IFeatureProvider fp) {
		super(fp)
	}

	override canUpdate(IUpdateContext context) {
		context.EAttribute != null
	}

	override updateNeeded(IUpdateContext context) {
		if (context.image.value != context.EAttribute.image) {
			return Reason::createTrueReason
		}

		if (context.text.value != context.EAttribute.text) {
			return Reason::createTrueReason
		}

		Reason::createFalseReason
	}

	override update(IUpdateContext context) {
		if (context.image.value != context.EAttribute.image) {
			context.image.value = context.EAttribute.image
		}

		if (context.text.value != context.EAttribute.text) {
			context.text.value = context.EAttribute.text
		}

		return true
	}
}
