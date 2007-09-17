Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 17 Sep 2007 08:03:08 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8HF32uw002135
	for <xfs@oss.sgi.com>; Mon, 17 Sep 2007 08:03:05 -0700
Message-ID: <46EE971A.2080302@sandeen.net>
Date: Mon, 17 Sep 2007 10:02:50 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Configuring XFS on Redhat Linux
References: <53F49A183F99D94D9C84E062566A97E3037C6E4C@SGPPCMEU302VEUA.INTRANET.BARCAPINT.COM>
In-Reply-To: <53F49A183F99D94D9C84E062566A97E3037C6E4C@SGPPCMEU302VEUA.INTRANET.BARCAPINT.COM>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Kumaraswamy.Namburu@barclayscapital.com
Cc: xfs@oss.sgi.com

Kumaraswamy.Namburu@barclayscapital.com wrote:
>  
> Hello Sandeen,
> 
>   Thank you very much for your mail. I am new to Linux Kernel
> Compilation. Could you please advise me the steps involved in enabling
> xfs filesystem on Linux version 2.6.9-22.Elsmp. I have  googled and
> tried few methods, but I have failed to enable XFS, Infact my machine is
> not booting up after xfs module installation. Please help me.

If you require xfs support for an enterprise-class Linux distribution
and you are not comfortable compiling your own kernel code, I would
suggest using something which already includes xfs support, such as
SuSE's SLES10.  Or, if you need xfs on RHEL, talk to Red Hat about that
need.

Otherwise I think I'd just be giving you enough rope to hang yourself. :)

-Eric
