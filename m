Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o03H5Z3C243415 for <xfs@oss.sgi.com>; Sun, 3 Jan 2010 11:05:35 -0600
Received: from firestarter.dermichi.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6A99E1DACCC9
	for <xfs@oss.sgi.com>; Sun,  3 Jan 2010 09:06:24 -0800 (PST)
Received: from firestarter.dermichi.com (firestarter.dermichi.com
	[78.41.115.230]) by cuda.sgi.com with ESMTP id Q75PBsB0F52cmuUk
	for <xfs@oss.sgi.com>; Sun, 03 Jan 2010 09:06:24 -0800 (PST)
Message-ID: <4B40CE8A.3070105@dermichi.com>
Date: Sun, 03 Jan 2010 18:06:18 +0100
From: Michael Weissenbacher <mw@dermichi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] remove bashisms from xfstests
References: <alpine.DEB.2.01.1001030125040.3483@bogon.housecafe.de>
	<87vdfjceke.fsf@basil.nowhere.org>
In-Reply-To: <87vdfjceke.fsf@basil.nowhere.org>
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
To: Andi Kleen <andi@firstfloor.org>
Cc: xfs@oss.sgi.com

>> Thoughts?
> 
> The usual much easier and less riskier change is to just change the
> first line in each script to #!/bin/bash
> 
Seconded, since there shouldn't be any linux distro around without /bin/bash 
installed.

(just IMHO of course)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
