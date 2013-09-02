package com.aljoschability.eclipse.ecodito.diagram.features;

import com.aljoschability.eclipse.core.graphiti.features.CoreCreateFeature
import com.aljoschability.eclipse.ecodito.diagram.util.EEnumExtensions
import org.eclipse.emf.ecore.EEnum
import org.eclipse.emf.ecore.EPackage
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
import org.eclipse.graphiti.util.IColorConstant

class EEnumCreateFeature extends CoreCreateFeature {
	extension EEnumExtensions = EEnumExtensions::INSTANCE

	new(IFeatureProvider fp) {
		super(fp)

		name = "Enumeration"
		description = "Create Enumeration"
		imageId = icon
		largeImageId = icon

		editable = true
	}

	override canCreate(ICreateContext context) {
		return context.targetContainer.businessObjectForPictogramElement instanceof EPackage
	}

	override createElement(ICreateContext context) {
		val p = context.targetContainer.businessObjectForPictogramElement as EPackage

		val element = EcoreFactory::eINSTANCE.createEEnum
		p.EClassifiers += element

		return element
	}
}

class EEnumAddFeature extends AbstractAddFeature {
	extension EEnumExtensions = EEnumExtensions::INSTANCE

	new(IFeatureProvider fp) {
		super(fp)
	}

	override add(IAddContext context) {
		addContainerShape[
			container = context.container
			active = true
			link = context.newObject
			val frame = addRoundedRectangle[
				background = IColorConstant::WHITE
				foreground = IColorConstant::BLACK
				radius = 16
				position = context.position
				size = context.size(200, 100)
				val titleSymbol = addImage[
					//name = "title.symbol"
					id = EEnum.simpleName
					position = #[7, 7]
					size = #[16, 16]
				]
				val titleText = addText[
					//name = "title.text"
					position = #[27, 5]
					width = parentGraphicsAlgorithm.width - 54
					foreground = IColorConstant::BLACK
					height = 20
					//font = nameFont
					value = "Test Calibri Font"
				]
				val titleSeparator = addPolyline[
					//name = "title.separator"
					addPoint(0, 29)
					addPoint(parentGraphicsAlgorithm.width, 29)
				]
			]
		]
	}

	override canAdd(IAddContext context) {
		context.EPackage != null && context.EEnum != null
	}
}

class EEnumLayoutFeature extends AbstractLayoutFeature {
	extension EEnumExtensions = EEnumExtensions::INSTANCE

	new(IFeatureProvider fp) {
		super(fp)
	}

	override canLayout(ILayoutContext context) {
		context.EEnum != null
	}

	override layout(ILayoutContext context) {
		false
	}
}

class EEnumUpdateFeature extends AbstractUpdateFeature {
	extension EEnumExtensions = EEnumExtensions::INSTANCE

	new(IFeatureProvider fp) {
		super(fp)
	}

	override canUpdate(IUpdateContext context) {
		context.EEnum != null
	}

	override updateNeeded(IUpdateContext context) {
		Reason::createFalseReason
	}

	override update(IUpdateContext context) {
		false
	}
}
