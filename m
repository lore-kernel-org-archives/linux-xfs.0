Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 24 Aug 2006 19:35:24 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k7P2YuDW013990
	for <xfs@oss.sgi.com>; Thu, 24 Aug 2006 19:35:08 -0700
Date: Fri, 25 Aug 2006 12:34:03 +1000
From: Nathan Scott <nathans@sgi.com>
Subject: Re: [PATCH] collapse sv_init, init_sv on linux
Message-ID: <20060825123403.A3026918@wobbly.melbourne.sgi.com>
References: <20060825022352.7E22C18DAFEC7@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20060825022352.7E22C18DAFEC7@sandeen.net>; from sandeen@sandeen.net on Thu, Aug 24, 2006 at 09:23:52PM -0500
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sandeen@sandeen.net
Cc: xfs@oss.sgi.com

On Thu, Aug 24, 2006 at 09:23:52PM -0500, sandeen@sandeen.net wrote:
> Change the one caller of init_sv on linux2.4 to sv_init, since there
> is no difference between sv_init & init_sv on linux anyway.
> 
> Then get rid of now unused init_sv.

Taa, queued up (along with one or two earlier ones I didn't
reply to yet).

thanks.

-- 
Nathan
