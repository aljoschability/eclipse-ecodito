package com.aljoschability.eclipse.ecodito.ui.patterns;

import org.eclipse.emf.ecore.EClass;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.emf.ecore.EPackage;
import org.eclipse.emf.ecore.EcoreFactory;
import org.eclipse.emf.ecore.EcorePackage;
import org.eclipse.graphiti.features.IReason;
import org.eclipse.graphiti.features.context.IAddContext;
import org.eclipse.graphiti.features.context.ICreateContext;
import org.eclipse.graphiti.features.context.IUpdateContext;
import org.eclipse.graphiti.mm.algorithms.Polyline;
import org.eclipse.graphiti.mm.algorithms.RoundedRectangle;
import org.eclipse.graphiti.mm.algorithms.Text;
import org.eclipse.graphiti.mm.pictograms.ContainerShape;
import org.eclipse.graphiti.mm.pictograms.PictogramElement;
import org.eclipse.graphiti.pattern.config.IPatternConfiguration;
import org.eclipse.graphiti.services.Graphiti;
import org.eclipse.graphiti.util.IColorConstant;

import com.aljoschability.eclipse.core.graphiti.pattern.CorePattern;

public class EClassPattern extends CorePattern {
	public EClassPattern(IPatternConfiguration patternConfiguration) {
		super();
	}

	@Override
	public PictogramElement add(IAddContext context) {
		ContainerShape cpe = context.getTargetContainer();

		ContainerShape pe = Graphiti.getPeService().createContainerShape(cpe, true);
		EClass bo = (EClass) context.getNewObject();
		link(pe, bo);

		// main rectangle
		RoundedRectangle ga = Graphiti.getGaService().createPlainRoundedRectangle(pe, 0, 0);
		ga.setCornerHeight(16);
		ga.setCornerWidth(16);
		ga.setLineWidth(1);
		ga.setBackground(manageColor(IColorConstant.WHITE));
		ga.setForeground(manageColor(IColorConstant.BLACK));

		ga.setX(context.getX());
		ga.setY(context.getY());
		ga.setWidth(context.getWidth());
		ga.setHeight(context.getHeight());

		// name text
		Text nameText = Graphiti.getGaService().createPlainText(ga);
		nameText.setValue(bo.getName());
		nameText.setForeground(manageColor(IColorConstant.BLACK));
		nameText.setFilled(false);

		nameText.setX(0);
		nameText.setY(0);
		nameText.setWidth(ga.getWidth());
		nameText.setHeight(20);

		// line
		int[] lineCoords = new int[] { 0, 20, ga.getWidth(), 20 };
		Polyline line = Graphiti.getGaService().createPlainPolyline(ga, lineCoords);
		line.setForeground(manageColor(IColorConstant.BLACK));
		line.setWidth(1);

		// line
		lineCoords = new int[] { 0, 20, ga.getWidth(), 20 };
		Polyline line2 = Graphiti.getGaService().createPlainPolyline(ga, lineCoords);
		line2.setForeground(manageColor(IColorConstant.BLACK));
		line2.setWidth(1);

		return pe;
	}

	@Override
	public IReason updateNeeded(IUpdateContext context) {
		PictogramElement pe = context.getPictogramElement();
		EObject bo = getBO(pe);

		// check name text
		

		return super.updateNeeded(context);
	}

	@Override
	protected EObject createElement(ICreateContext context) {
		EPackage ePackage = (EPackage) getBO(context.getTargetContainer());

		EClass element = EcoreFactory.eINSTANCE.createEClass();
		ePackage.getEClassifiers().add(element);

		return element;
	}

	@Override
	public boolean canCreate(ICreateContext context) {
		return getBO(context.getTargetContainer()) instanceof EPackage;
	}

	@Override
	protected boolean isBO(Object bo) {
		return bo instanceof EClass;
	}

	@Override
	protected EClass getEClass() {
		return EcorePackage.Literals.ECLASS;
	}
}
