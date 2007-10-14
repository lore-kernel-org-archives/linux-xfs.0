Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 14 Oct 2007 07:49:43 -0700 (PDT)
Received: from postfix2-g20.free.fr (postfix2-g20.free.fr [212.27.60.43])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l9EEnVfL019415
	for <xfs@oss.sgi.com>; Sun, 14 Oct 2007 07:49:33 -0700
Received: from smtp7-g19.free.fr (smtp7-g19.free.fr [212.27.42.64])
	by postfix2-g20.free.fr (Postfix) with ESMTP id 010C21BBD132
	for <xfs@oss.sgi.com>; Sun, 14 Oct 2007 14:48:30 +0200 (CEST)
Date: Sun, 14 Oct 2007 16:49:23 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: Latencies in XFS.
Message-ID: <20071014164923.083d55dd@galadriel.home>
In-Reply-To: <20071014012323.1d6c9e8e@alpha.digital-domain.net>
References: <20071009163635.413dec0c@zeus.pccl.info>
	<20071013201015.4a8008bb@galadriel.home>
	<20071014012323.1d6c9e8e@alpha.digital-domain.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Andrew Clayton <andrew@digital-domain.net>
Cc: xfs@oss.sgi.com

Le Sun, 14 Oct 2007 01:23:23 +0100 vous écriviez:

> > I notice you use a bleeding-edge unstable kernel, with a whole new
> > scheduler. I tried your benchmark on a machine running a known
> > stable kernel (2.6.20.17) and the slowdown is similar in xfs and
> > other fs.  
> 
> I don't see the slowdown in ext3.

I tried it and the slowdown is proportionnally similar, though XFS is
slower IO-wise.

-- 
--------------------------------------------------
Emmanuel Florac               www.intellique.com   
--------------------------------------------------
