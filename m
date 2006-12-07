Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 07 Dec 2006 14:19:43 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kB7MJaaG003140
	for <xfs@oss.sgi.com>; Thu, 7 Dec 2006 14:19:37 -0800
Message-ID: <45789341.6000809@sandeen.net>
Date: Thu, 07 Dec 2006 16:18:41 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: New CentOS4/RHEL4-compatible xfs module rpms
References: <4560AB84.9060200@sandeen.net> <45784E71.4080605@falconstor.com>	 <457854CB.5030507@sandeen.net>  <45787ED4.5070801@falconstor.com>	 <1165525906.30459.25.camel@edge>  <45788927.4030207@falconstor.com>	 <1165527628.30459.31.camel@edge>  <45788CD1.9010509@falconstor.com> <1165529205.30459.36.camel@edge> <457892BB.1000203@falconstor.com>
In-Reply-To: <457892BB.1000203@falconstor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: geir.myrestrand@falconstor.com
Cc: xfs@oss.sgi.com, nscott@aconex.com

Geir A. Myrestrand wrote:
> Nathan Scott wrote:
>> On Thu, 2006-12-07 at 16:51 -0500, Geir A. Myrestrand wrote:
>>> Sorry Nathan, but I'm not sure I understand what you refer to with
>>> "test out the latest" --are you referring to the kernel or XFS?
>> Yes. :)  Current mainline kernels, or CVS from oss.sgi.com would
>> have this fix I'm thinking of.
> 
> Thanks for the "clarification"... ;-)
> 
> I'll try to update the XFS code first, hopefully it won't break too many 
> of the patches Eric had in his source RPM...but I will try to correct 
> them if they fail to apply cleanly...
> 
> I'll keep you posted.
> 

I would just get kernel-2.6.19 and run the test, see if it's fixed
upstream, don't worry about merging & munging xfs code from one place o
another...

-Eric
