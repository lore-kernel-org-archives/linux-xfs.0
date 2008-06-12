Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 12 Jun 2008 15:31:02 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5CMUu8Y031826
	for <xfs@oss.sgi.com>; Thu, 12 Jun 2008 15:30:56 -0700
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6DCF117BA8D6
	for <xfs@oss.sgi.com>; Thu, 12 Jun 2008 15:31:53 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31]) by cuda.sgi.com with ESMTP id oUkZDMN0HUDcjNCW for <xfs@oss.sgi.com>; Thu, 12 Jun 2008 15:31:53 -0700 (PDT)
Message-ID: <4851A3D6.809@sandeen.net>
Date: Thu, 12 Jun 2008 17:31:50 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: mkfs.xfs man page
References: <4851A36B.6030404@sauce.co.nz>
In-Reply-To: <4851A36B.6030404@sauce.co.nz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Richard Scobie <richard@sauce.co.nz>
Cc: xfs@oss.sgi.com

Richard Scobie wrote:
> The latest xfsprogs, 2.9.8-1 makes no mention of the "-d unwritten" 
> option in the mkfs.xfs man page.
> 
> Not sure if this is by design or not.
> 
> Regards,
> 
> Richard


It is intentional:

http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/man/man8/mkfs.xfs.8#rev1.30

Thanks,
-Eric
