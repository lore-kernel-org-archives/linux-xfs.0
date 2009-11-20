Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nAKLNPG8200491 for <xfs@oss.sgi.com>; Fri, 20 Nov 2009 15:23:25 -0600
Received: from millhouse.houseofnate.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 34D1518B89D0
	for <xfs@oss.sgi.com>; Fri, 20 Nov 2009 13:23:48 -0800 (PST)
Received: from millhouse.houseofnate.net
	(dsl092-086-237.bos1.dsl.speakeasy.net [66.92.86.237]) by
	cuda.sgi.com with ESMTP id FMPLgfBreyLJagkc for
	<xfs@oss.sgi.com>; Fri, 20 Nov 2009 13:23:48 -0800 (PST)
Message-ID: <4B0708C5.7000307@houseofnate.net>
Date: Fri, 20 Nov 2009 16:23:17 -0500
From: "Nathaniel W. Turner" <nate@houseofnate.net>
MIME-Version: 1.0
Subject: Re: XFS, NFS and inode64 on 2.6.27
References: <200911201152.43809@zmi.at>
In-Reply-To: <200911201152.43809@zmi.at>
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
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Cc: xfs@oss.sgi.com

Michael Monnerie wrote:
> after searching for a long time I guess I found that inode64 on XFS with 
> kernel 2.6.27 (shipped with openSUSE 11.1) is incompatible with NFS. 
> Sorry if this was already know, it wasn't for me and finding the problem 
> was complicated.
>   
Interesting.  I've never tried this, but I've read things that imply it 
should work.
Just out of curiosity, is your NFS client also running a 64-bit kernel?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
