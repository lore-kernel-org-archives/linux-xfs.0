Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 18 Oct 2008 02:11:13 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9I9B8CI024019
	for <xfs@oss.sgi.com>; Sat, 18 Oct 2008 02:11:10 -0700
Received: from sv13.net-housting.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D49E05114E1
	for <xfs@oss.sgi.com>; Sat, 18 Oct 2008 02:12:52 -0700 (PDT)
Received: from sv13.net-housting.de (sv13.net-housting.de [80.190.144.123]) by cuda.sgi.com with ESMTP id 1vdbIwF631GsPjP1 for <xfs@oss.sgi.com>; Sat, 18 Oct 2008 02:12:52 -0700 (PDT)
From: Tobias Frost <tobi@coldtobi.de>
In-Reply-To: <20081017094615.GT4504@soziologie.ch>
References: <1222893502.5020.40.camel@moria>
	 <20081002004556.GB30001@disturbed> <48E4213E.9090508@sandeen.net>
	 <20081016212500.GA27228@deprecation.cyrius.com>
	 <48F7BC9F.4080909@sandeen.net>
	 <20081017070109.GA30726@deprecation.cyrius.com>
	 <20081017094615.GT4504@soziologie.ch>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Sat, 18 Oct 2008 15:11:14 +0200
Message-Id: <1224335474.8763.1.camel@moria>
Mime-Version: 1.0
Subject: Re: XFS filesystem corruption on the arm(el) architecture
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Gaudenz Steinlin <gaudenz@debian.org>
Cc: Martin Michlmayr <tbm@cyrius.com>, Eric Sandeen <sandeen@sandeen.net>, linux-kernel@vger.kernel.org, debian-arm@lists.debian.org, xfs@oss.sgi.com

I tried xfs both on the old and new ABI.
(my first try was Jan 2008, old ABI) 
ASAIR at kernel version 2.6.18

On Fri, 2008-10-17 at 11:46 +0200, Gaudenz Steinlin wrote:
> On Fri, Oct 17, 2008 at 09:01:09AM +0200, Martin Michlmayr wrote:
> > * Eric Sandeen <sandeen@sandeen.net> [2008-10-16 17:13]:
> > > So is this a regression?  did it used to work?  If so, when? :)
> > 
> > The original report was with 2.6.18 but that was with the old ABI:
> > http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=423562
> > I just installed a 2.6.22 kernel with EABI and I can also trigger
> > the bug.  So it's not a (recent) regression.
> 
> As far as I can remember (I only used old ABI arm) this is not a 
> regression. XFS never worked on arm for me.
> 
> If you need tests on old ABI just tell me.
> 
