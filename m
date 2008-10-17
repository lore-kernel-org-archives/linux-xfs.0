Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 17 Oct 2008 02:41:33 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9H9fQGS023261
	for <xfs@oss.sgi.com>; Fri, 17 Oct 2008 02:41:27 -0700
Received: from ping.pong.ch (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EB23812A6074
	for <xfs@oss.sgi.com>; Fri, 17 Oct 2008 02:43:09 -0700 (PDT)
Received: from ping.pong.ch (ping.pong.ch [212.103.71.101]) by cuda.sgi.com with ESMTP id AHgk6z65PPZantn8 for <xfs@oss.sgi.com>; Fri, 17 Oct 2008 02:43:09 -0700 (PDT)
Date: Fri, 17 Oct 2008 11:46:15 +0200
From: Gaudenz Steinlin <gaudenz@debian.org>
Subject: Re: XFS filesystem corruption on the arm(el) architecture
Message-ID: <20081017094615.GT4504@soziologie.ch>
References: <1222893502.5020.40.camel@moria> <20081002004556.GB30001@disturbed> <48E4213E.9090508@sandeen.net> <20081016212500.GA27228@deprecation.cyrius.com> <48F7BC9F.4080909@sandeen.net> <20081017070109.GA30726@deprecation.cyrius.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081017070109.GA30726@deprecation.cyrius.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Martin Michlmayr <tbm@cyrius.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, Tobias Frost <tobi@coldtobi.de>, linux-kernel@vger.kernel.org, debian-arm@lists.debian.org, xfs@oss.sgi.com

On Fri, Oct 17, 2008 at 09:01:09AM +0200, Martin Michlmayr wrote:
> * Eric Sandeen <sandeen@sandeen.net> [2008-10-16 17:13]:
> > So is this a regression?  did it used to work?  If so, when? :)
> 
> The original report was with 2.6.18 but that was with the old ABI:
> http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=423562
> I just installed a 2.6.22 kernel with EABI and I can also trigger
> the bug.  So it's not a (recent) regression.

As far as I can remember (I only used old ABI arm) this is not a 
regression. XFS never worked on arm for me.

If you need tests on old ABI just tell me.

-- 
Ever tried. Ever failed. No matter.
Try again. Fail again. Fail better.
~ Samuel Beckett ~
