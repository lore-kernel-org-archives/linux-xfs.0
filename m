Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 06 Jul 2008 20:03:48 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6733l2A022678
	for <xfs@oss.sgi.com>; Sun, 6 Jul 2008 20:03:47 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B04E71883F1D
	for <xfs@oss.sgi.com>; Sun,  6 Jul 2008 20:04:51 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id SbhyuS47PCUNvXKL for <xfs@oss.sgi.com>; Sun, 06 Jul 2008 20:04:51 -0700 (PDT)
Message-ID: <487187D2.8080105@sandeen.net>
Date: Sun, 06 Jul 2008 22:04:50 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Xfs Access to block zero  exception and system crash
References: <486B01A6.4030104@pmc-sierra.com> <20080702051337.GX29319@disturbed> <486B13AD.2010500@pmc-sierra.com> <1214979191.6025.22.camel@verge.scott.net.au> <20080702065652.GS14251@build-svl-1.agami.com> <486B6062.6040201@pmc-sierra.com> <486C4F89.9030009@sandeen.net> <486C6053.7010503@pmc-sierra.com> <486CE9EA.90502@sandeen.net> <486DF8F0.5010700@pmc-sierra.com> <20080704122726.GG29319@disturbed> <340C71CD25A7EB49BFA81AE8C839266702997641@BBY1EXM10.pmc_nt.nt.pmc-sierra.bc.ca> <486E5F4D.1010009@sandeen.net> <340C71CD25A7EB49BFA81AE8C839266702997658@BBY1EXM10.pmc_nt.nt.pmc-sierra.bc.ca> <486FA095.1050106@sandeen.net> <340C71CD25A7EB49BFA81AE8C839266702A084A6@BBY1EXM10.pmc_nt.nt.pmc-sierra.bc.ca> <487117FC.9090109@sandeen.net> <4871872B.9060107@pmc-sierra.com>
In-Reply-To: <4871872B.9060107@pmc-sierra.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Sagar Borikar <sagar_borikar@pmc-sierra.com>
Cc: Dave Chinner <david@fromorbit.com>, Nathan Scott <nscott@aconex.com>, xfs@oss.sgi.com

Sagar Borikar wrote:


> There was no failure. Only the processes were stalled. System was 
> operative.


I'm curious, if the processes were stalled, how did you unmount the
filesystem to run repair on it?

-Eric
