Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4PAjpWk099199 for <xfs@oss.sgi.com>; Fri, 25 May 2012 05:45:51 -0500
Received: from mailgw1.uni-kl.de (mailgw1.uni-kl.de [131.246.120.220]) by
	cuda.sgi.com with ESMTP id Se27U4AIFT2hzq8u (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 25 May 2012 03:45:49 -0700 (PDT)
Received: from itwm2.itwm.fhg.de (itwm2.itwm.fhg.de [131.246.191.3])
	by mailgw1.uni-kl.de (8.14.3/8.14.3/Debian-5+lenny1) with ESMTP id
	q4PAjdn4006635
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NOT)
	for <xfs@oss.sgi.com>; Fri, 25 May 2012 12:45:40 +0200
Message-ID: <4FBF62D2.20702@fastmail.fm>
Date: Fri, 25 May 2012 12:45:38 +0200
From: Bernd Schubert <bernd.schubert@fastmail.fm>
MIME-Version: 1.0
Subject: Re: very slow file deletion on an SSD
References: <4FBF60D1.80104@gmail.com>
In-Reply-To: <4FBF60D1.80104@gmail.com>
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
To: Joe Landman <joe.landman@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, xfs@oss.sgi.com

Hello Joe,

On 05/25/2012 12:37 PM, Joe Landman wrote:
> Hi folks:
>
> Just ran into this (see posted output at bottom). 3.2.14 kernel, MD RAID
> 5, xfs file system. Not sure (precisely) where the problem is, hence
> posting to both lists.

do you have anything enabled, that would make your files to have xattrs?


http://oss.sgi.com/archives/xfs/2011-08/msg00233.html


Cheers,
Bernd

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
