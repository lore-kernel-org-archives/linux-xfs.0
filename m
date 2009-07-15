Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6FDvdwn200809 for <xfs@oss.sgi.com>; Wed, 15 Jul 2009 08:57:39 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E7DDD149D30A
	for <xfs@oss.sgi.com>; Wed, 15 Jul 2009 07:05:52 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id IamCTmjC8JoxDIZF for
	<xfs@oss.sgi.com>; Wed, 15 Jul 2009 07:05:52 -0700 (PDT)
Message-ID: <4A5DE078.3040005@sandeen.net>
Date: Wed, 15 Jul 2009 08:58:16 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: How to simulate journal corruption
References: <SNT109-W2390816D3EF297CE0D07DEEC220@phx.gbl>
	<4A5B4833.9070300@sandeen.net>
	<SNT109-W27FBC11B3A147486A10FAAEC200@phx.gbl>
	<249A89BAA060C94FA0B93EA6135CC93C084463AD@xmb-rtp-20b.amer.cisco.com>
In-Reply-To: <249A89BAA060C94FA0B93EA6135CC93C084463AD@xmb-rtp-20b.amer.cisco.com>
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
To: "Wentao Lv (wentalv)" <wentalv@cisco.com>
Cc: xfs@oss.sgi.com

Wentao Lv (wentalv) wrote:
> Hi, Eric
> 
>  
> 
> Could you tell me where I could find XFS-QA test cases?
> 

http://git.kernel.org/?p=fs/xfs/xfstests-dev.git;a=summary

is devel stuff, often a bit ahead of the "official" repo which is at:

http://oss.sgi.com/cgi-bin/gitweb.cgi?p=xfs/cmds/xfstests.git;a=summary

-Eric

> 
> Thanks & Regards.
> 
> Lv Wentao.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
