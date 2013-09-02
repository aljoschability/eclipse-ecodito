package com.aljoschability.eclipse.ecodito.diagram.features;

import com.aljoschability.eclipse.core.graphiti.features.CoreCreateFeature
import com.aljoschability.eclipse.core.graphiti.pattern.CorePattern
import org.eclipse.emf.ecore.EDataType
import org.eclipse.emf.ecore.EPackage
import org.eclipse.emf.ecore.EcoreFactory
import org.eclipse.emf.ecore.EcorePackage
import org.eclipse.graphiti.features.IFeatureProvider
import org.eclipse.graphiti.features.context.IAddContext
import org.eclipse.graphiti.features.context.ICreateContext
import org.eclipse.graphiti.features.impl.AbstractAddFeature
import org.eclipse.graphiti.pattern.config.IPatternConfiguration
import org.eclipse.emf.ecore.EEnum
import com.aljoschability.eclipse.core.graphiti.util.GraphitiExtensions
import org.eclipse.graphiti.util.IColorConstant
import org.eclipse.graphiti.mm.algorithms.GraphicsAlgorithm

class EDataTypeCreateFeature extends CoreCreateFeature {
	new(IFeatureProvider fp) {
		super(fp)

		name = "EDataType"
		description = "Create EDataType"
		imageId = EDataType.simpleName
		largeImageId = EDataType.simpleName

		editable = true
	}

	override canCreate(ICreateContext context) {
		return context.targetContainer.businessObjectForPictogramElement instanceof EPackage
	}

	override createElement(ICreateContext context) {
		val p = context.targetContainer.businessObjectForPictogramElement as EPackage

		val element = EcoreFactory::eINSTANCE.createEDataType
		p.EClassifiers += element

		return element
	}
}

class EDataTypeAddFeature extends AbstractAddFeature {
	extension GraphitiExtensions = GraphitiExtensions::INSTANCE

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
					id = EDataType.simpleName
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
		context.newObject instanceof EDataType && !(context.newObject instanceof EEnum) &&
			context.targetContainer.bo instanceof EPackage
	}

	def void setBackground(GraphicsAlgorithm ga, IColorConstant color) {
		ga.background = manageColor(color)
	}

	def void setForeground(GraphicsAlgorithm ga, IColorConstant color) {
		ga.foreground = manageColor(color)
	}
}

class EDataTypePattern extends CorePattern {
	new(IPatternConfiguration patternConfiguration) {
		super();
	}

	override canCreate(ICreateContext context) {
		val pe = context.getTargetContainer();
		return getBO(pe) instanceof EPackage;
	}

	override protected isBO(Object bo) {
		return bo instanceof EDataType;
	}

	override protected getEClass() {
		return EcorePackage.Literals.EDATA_TYPE;
	}
}
