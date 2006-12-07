Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 07 Dec 2006 13:41:39 -0800 (PST)
Received: from postoffice.aconex.com (mail.app.aconex.com [203.89.192.138])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kB7LfQaG030384
	for <xfs@oss.sgi.com>; Thu, 7 Dec 2006 13:41:29 -0800
Subject: Re: New CentOS4/RHEL4-compatible xfs module rpms
From: Nathan Scott <nscott@aconex.com>
Reply-To: nscott@aconex.com
In-Reply-To: <45788927.4030207@falconstor.com>
References: <4560AB84.9060200@sandeen.net> <45784E71.4080605@falconstor.com>
	 <457854CB.5030507@sandeen.net>  <45787ED4.5070801@falconstor.com>
	 <1165525906.30459.25.camel@edge>  <45788927.4030207@falconstor.com>
Content-Type: text/plain
Date: Fri, 08 Dec 2006 08:40:28 +1100
Message-Id: <1165527628.30459.31.camel@edge>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: geir.myrestrand@falconstor.com
Cc: xfs@oss.sgi.com, Eric Sandeen <sandeen@sandeen.net>

On Thu, 2006-12-07 at 16:35 -0500, Geir A. Myrestrand wrote:
> 
> It wouldn't be easy for me to switch to a newer kernel, because it is 
> not just a matter of my machine --we have a product built for this 
> particular configuration. Switching to a new kernel would reset our 
> QA efforts.

You misunderstood me I think - I didn't suggest switching kernels, just
that you test out the latest.  If its OK, then its relatively easy to
search for a change that fixed it.  If its not OK, then theres a bug in
mainline which should get some attention too.

cheers.

-- 
Nathan
