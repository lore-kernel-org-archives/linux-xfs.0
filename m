Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2CNE6oB105067 for <xfs@oss.sgi.com>; Thu, 12 Mar 2009 18:14:27 -0500
Received: from idcmail-mo2no.shaw.ca (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D9DC71C3B6D8
	for <xfs@oss.sgi.com>; Thu, 12 Mar 2009 16:13:43 -0700 (PDT)
Received: from idcmail-mo2no.shaw.ca (idcmail-mo2no.shaw.ca [64.59.134.9]) by
	cuda.sgi.com with ESMTP id 4AjJPXr3TLpF7svw for
	<xfs@oss.sgi.com>; Thu, 12 Mar 2009 16:13:43 -0700 (PDT)
Message-ID: <58707.24.80.224.145.1236899620.squirrel@squirrel.kevinjamieson.com>
In-Reply-To: <49B9611F.5040009@sandeen.net>
References: <64323.24.80.224.145.1236883814.squirrel@squirrel.kevinjamieson.com>
	<49B9611F.5040009@sandeen.net>
Date: Thu, 12 Mar 2009 16:13:40 -0700 (PDT)
Subject: Re: Oops at xfs_bmbt_get_startoff in SLES 10 2.6.16
From: "Kevin Jamieson" <kevin@kevinjamieson.com>
MIME-Version: 1.0
Reply-To: kevin@kevinjamieson.com
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On Thu, March 12, 2009 12:23 pm, Eric Sandeen wrote:

> For SLES that usually is the best route...
>
> However, http://oss.sgi.com/archives/xfs/2009-02/msg00220.html looks
> applicable... don't think it ever got merged though.
>
> perhaps you could test it?

Thanks, Eric. I will test Lachlan's patch on our system.

Kevin

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
