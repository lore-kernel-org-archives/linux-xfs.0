Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o03GtoKX242308 for <xfs@oss.sgi.com>; Sun, 3 Jan 2010 10:55:50 -0600
Received: from one.firstfloor.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5A3441DACD2E
	for <xfs@oss.sgi.com>; Sun,  3 Jan 2010 08:56:39 -0800 (PST)
Received: from one.firstfloor.org (one.firstfloor.org [213.235.205.2]) by
	cuda.sgi.com with ESMTP id NclffNPM5TUbtqig for
	<xfs@oss.sgi.com>; Sun, 03 Jan 2010 08:56:39 -0800 (PST)
Subject: Re: [PATCH] remove bashisms from xfstests
From: Andi Kleen <andi@firstfloor.org>
References: <alpine.DEB.2.01.1001030125040.3483@bogon.housecafe.de>
Date: Sun, 03 Jan 2010 17:56:33 +0100
In-Reply-To: <alpine.DEB.2.01.1001030125040.3483@bogon.housecafe.de>
	(Christian Kujau's message of "Sun,
	3 Jan 2010 02:30:05 -0800 (PST)")
Message-ID: <87vdfjceke.fsf@basil.nowhere.org>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christian Kujau <lists@nerdbynature.de>
Cc: xfs@oss.sgi.com

Christian Kujau <lists@nerdbynature.de> writes:
>
> Thoughts?

The usual much easier and less riskier change is to just change the
first line in each script to #!/bin/bash

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
