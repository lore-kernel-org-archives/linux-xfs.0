Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAOMqDlf174593 for <xfs@oss.sgi.com>; Wed, 24 Nov 2010 16:52:13 -0600
Received: from BLADE3.ISTI.CNR.IT (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B27401C704C8
	for <xfs@oss.sgi.com>; Wed, 24 Nov 2010 14:53:50 -0800 (PST)
Received: from BLADE3.ISTI.CNR.IT (blade3.isti.cnr.it [194.119.192.19]) by
	cuda.sgi.com with ESMTP id qPddTeiGzuuj9Iwm for
	<xfs@oss.sgi.com>; Wed, 24 Nov 2010 14:53:50 -0800 (PST)
Received: from SCRIPT-SPFWL-DAEMON.mx.isti.cnr.it by mx.isti.cnr.it
	(PMDF V6.5 #31825) id <01NUNIS2TWOGLGZAP7@mx.isti.cnr.it> for
	xfs@oss.sgi.com; Wed, 24 Nov 2010 23:53:15 +0100 (MET)
Received: from conversionlocal.isti.cnr.it by mx.isti.cnr.it (PMDF V6.5 #31825)
	id <01NUNIPGMVPCLKNKT8@mx.isti.cnr.it> for xfs@oss.sgi.com; Wed,
	24 Nov 2010 23:52:29 +0100 (MET)
Received: from [151.83.239.60] by mx.isti.cnr.it (PMDF V6.5 #31826)
	with ESMTPSA id <01NUNIPAPVH8LLWYH1@mx.isti.cnr.it> for xfs@oss.sgi.com;
	Wed, 24 Nov 2010 23:50:37 +0100 (MET)
Date: Wed, 24 Nov 2010 23:52:43 +0100
From: Spelic <spelic@shiftmail.org>
Subject: Re: Xfs delaylog hanged up
In-reply-to: <4CEAC412.9000406@shiftmail.org>
Message-id: <4CED973B.60102@shiftmail.org>
MIME-version: 1.0
References: <4CEAC412.9000406@shiftmail.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

On 11/22/2010 08:27 PM, Spelic wrote:
> ....
> I was doing a parallel-kernel-unpack benchmark:
> ....

I tried to reproduce it today but unfortunately I wasn't able to, not 
even on the same hardware.

The first time it happened so soon after starting such 
parallel-kernel-unpack benchmark (at the second run!) that I was 
confident it was possible to reproduce it easily, but today in many 
hours it never happened again. Sorry. Unfortunately the machine is going 
back to production soon so I'm not sure I can do further testing.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
