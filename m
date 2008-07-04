Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 04 Jul 2008 05:26:42 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m64CQeKH027761
	for <xfs@oss.sgi.com>; Fri, 4 Jul 2008 05:26:40 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D2A201878EEC
	for <xfs@oss.sgi.com>; Fri,  4 Jul 2008 05:27:42 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id 8cv2Ffabi6dDN0sJ for <xfs@oss.sgi.com>; Fri, 04 Jul 2008 05:27:42 -0700 (PDT)
Date: Fri, 4 Jul 2008 22:27:26 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Xfs Access to block zero  exception and system crash
Message-ID: <20080704122726.GG29319@disturbed>
References: <486B01A6.4030104@pmc-sierra.com> <20080702051337.GX29319@disturbed> <486B13AD.2010500@pmc-sierra.com> <1214979191.6025.22.camel@verge.scott.net.au> <20080702065652.GS14251@build-svl-1.agami.com> <486B6062.6040201@pmc-sierra.com> <486C4F89.9030009@sandeen.net> <486C6053.7010503@pmc-sierra.com> <486CE9EA.90502@sandeen.net> <486DF8F0.5010700@pmc-sierra.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <486DF8F0.5010700@pmc-sierra.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Sagar Borikar <sagar_borikar@pmc-sierra.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, Nathan Scott <nscott@aconex.com>, xfs@oss.sgi.com

On Fri, Jul 04, 2008 at 03:48:24PM +0530, Sagar Borikar wrote:
> Even we too don't want to leave it as it is.  I still am working on back  
> porting the latest xfs code.
> Your patches are helping a lot .
> Just to check whether that issue lies with 2.6.18 or MIPS port, I tested  
> it on 2.6.24 x86 platform.
> Here we created a loop back device of 10 GB and mounted xfs on that.

And the script that generates the workload can be found where?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
