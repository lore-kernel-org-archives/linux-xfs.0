Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 10 Jul 2007 23:18:37 -0700 (PDT)
Received: from postoffice.aconex.com (mail.app.aconex.com [203.89.192.138])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6B6IYbm003081
	for <xfs@oss.sgi.com>; Tue, 10 Jul 2007 23:18:35 -0700
Subject: Re: REVIEW: Improve xfs_io and xfs_quota -c handling
From: Nathan Scott <nscott@aconex.com>
Reply-To: nscott@aconex.com
In-Reply-To: <op.tvadmnqf3jf8g2@pc-bnaujok.melbourne.sgi.com>
References: <op.tvadmnqf3jf8g2@pc-bnaujok.melbourne.sgi.com>
Content-Type: text/plain
Date: Wed, 11 Jul 2007 16:18:06 +1000
Message-Id: <1184134686.15488.498.camel@edge.yarra.acx>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>, xfs-dev <xfs-dev@sgi.com>

On Wed, 2007-07-11 at 16:00 +1000, Barry Naujok wrote:
> 
> The attached patch addresses this issue, and also allows
> "-c help [xxx]" in xfs_io without a file. xfs_quota will
> not print help once for each XFS filesystem either. 

Looks alright to me.

cheers.

--
Nathan
