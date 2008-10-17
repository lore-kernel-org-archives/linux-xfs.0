Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 17 Oct 2008 06:47:59 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9HDlrSG021467
	for <xfs@oss.sgi.com>; Fri, 17 Oct 2008 06:47:54 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7D4B71425E0C
	for <xfs@oss.sgi.com>; Fri, 17 Oct 2008 06:49:35 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id rxJJ4bI9z0gAIIsH for <xfs@oss.sgi.com>; Fri, 17 Oct 2008 06:49:35 -0700 (PDT)
Message-ID: <48F897ED.1060206@sandeen.net>
Date: Fri, 17 Oct 2008 08:49:33 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: XFS filesystem corruption on the arm(el) architecture
References: <1222893502.5020.40.camel@moria> <20081002004556.GB30001@disturbed> <48E4213E.9090508@sandeen.net> <20081016212500.GA27228@deprecation.cyrius.com> <48F7BC9F.4080909@sandeen.net> <20081017070109.GA30726@deprecation.cyrius.com> <20081017094615.GT4504@soziologie.ch>
In-Reply-To: <20081017094615.GT4504@soziologie.ch>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Martin Michlmayr <tbm@cyrius.com>, Eric Sandeen <sandeen@sandeen.net>, Tobias Frost <tobi@coldtobi.de>, linux-kernel@vger.kernel.org, debian-arm@lists.debian.org, xfs@oss.sgi.com

Gaudenz Steinlin wrote:
> On Fri, Oct 17, 2008 at 09:01:09AM +0200, Martin Michlmayr wrote:
>> * Eric Sandeen <sandeen@sandeen.net> [2008-10-16 17:13]:
>>> So is this a regression?  did it used to work?  If so, when? :)
>> The original report was with 2.6.18 but that was with the old ABI:
>> http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=423562
>> I just installed a 2.6.22 kernel with EABI and I can also trigger
>> the bug.  So it's not a (recent) regression.
> 
> As far as I can remember (I only used old ABI arm) this is not a 
> regression. XFS never worked on arm for me.

Ok; I think there are probably a few problems, so trying to keep them
straight.  I at least had xfs working properly in a qemu arm emulator a
few weeks ago... :)

> If you need tests on old ABI just tell me.
> 

ok, thanks!

-Eric
