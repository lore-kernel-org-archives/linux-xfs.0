Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 15 Mar 2007 08:52:10 -0700 (PDT)
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l2FFpx6p026890
	for <xfs@oss.sgi.com>; Thu, 15 Mar 2007 08:52:03 -0700
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: XFS on Redhat4 U4
Date: Thu, 15 Mar 2007 15:51:34 -0000
Message-ID: <4BE67D4A1485054E99B21710FF21A9CD020BEA29@swsmsx411.ger.corp.intel.com>
In-Reply-To: <alpine.LRH.0.83.0703151043190.10425@chaos.egr.duke.edu>
From: "Carassale, Mario" <mario.carassale@intel.com>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Joshua Baker-LePain <jlb17@duke.edu>
Cc: xfs@oss.sgi.com

Do we have a guide on how to build this, or is just an rpm that need to
be installed after OS installation.



Regards,
 
Mario Carassale
tel: 01793 404729
iTel: (8) 281 4729
Intel Corporation (UK) Ltd
mario.carassale@intel.com

 
 
 

-----Original Message-----
From: Joshua Baker-LePain [mailto:jlb17@duke.edu] 
Sent: 15 March 2007 14:47
To: Carassale, Mario
Cc: xfs@oss.sgi.com
Subject: Re: XFS on Redhat4 U4

On Thu, 15 Mar 2007 at 2:30pm, Carassale, Mario wrote

> Is there any way to run XFS on RedHat 4 U4.
>
Centos (a RHEL rebuild distro) provides a kernel module RPM with updated

(from that contained in the RHEL kernel source) XFS code.  See (e.g.):

http://mirror.centos.org/centos/4/centosplus/i386/RPMS/kernel-module-xfs
-2.6.9-42.0.10.ELsmp-0.2-1.i686.rpm

(modify based on kernel version and architecture, obviously).

-- 
Joshua Baker-LePain
Department of Biomedical Engineering
Duke University
