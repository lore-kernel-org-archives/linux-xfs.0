Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 28 Jun 2007 13:39:06 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l5SKcvtL019445
	for <xfs@oss.sgi.com>; Thu, 28 Jun 2007 13:38:58 -0700
Message-ID: <46841C60.5030207@sandeen.net>
Date: Thu, 28 Jun 2007 16:38:56 -0400
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfs_fsr, performance related tweaks
References: <4683ADEB.3010106@corky.net>
In-Reply-To: <4683ADEB.3010106@corky.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Just Marc <marc@corky.net>
Cc: xfs@oss.sgi.com

Just Marc wrote:

> 2. Files for which 'No improvement will be made' should also be marked 
> as no-defrag, this will avoid a ton of extra work in the future.   

But... that file could drastically change in the future, no?  Just
because it can't be improved now doesn't necessarily mean that it should
never be revisited on subsequent runs, does it?

-Eric
