Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 29 Jan 2008 07:33:35 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m0TFXRgt011612
	for <xfs@oss.sgi.com>; Tue, 29 Jan 2008 07:33:28 -0800
Received: from enyo.dsw2k3.info (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8EDA357443E
	for <xfs@oss.sgi.com>; Tue, 29 Jan 2008 07:33:49 -0800 (PST)
Received: from enyo.dsw2k3.info (enyo.dsw2k3.info [195.71.86.239]) by cuda.sgi.com with ESMTP id 1HBWGfGaMBXRbKWh for <xfs@oss.sgi.com>; Tue, 29 Jan 2008 07:33:49 -0800 (PST)
Date: Tue, 29 Jan 2008 16:33:37 +0100
From: Matthias Schniedermeyer <ms@citd.de>
Subject: Re: mkfs.xfs doesn't detect size of storage correctly
Message-ID: <20080129153337.GA20509@citd.de>
References: <20080129093201.GA16203@citd.de> <43347.192.168.3.1.1201601702.squirrel@mail.aconex.com> <20080129122051.GA18165@citd.de> <479F440F.2060506@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <479F440F.2060506@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: nscott@aconex.com, xfs@oss.sgi.com

On 29.01.2008 09:19, Eric Sandeen wrote:
> Matthias Schniedermeyer wrote:
> 
> > A maybe important detail, i forgot to mention in the original mail is:
> > The machine has 8GB of RAM, so i compiled the kernel with "64bit=yes" 
> > (formaly x86_64), BUT(!) the userspace is 32bit or plain old i386.
> 
> If you think that's the issue, I'd try compiling the above as a 32-bit
> binary and re-run.

I don't think it's an issue, i just wanted to mention it.

But as soon as i get home i will connect the HDD to an all 32bit system 
and see if it makes a difference. (I'm still undecided if i should hope 
that it makes a difference. ;-) )




Bis denn

-- 
Real Programmers consider "what you see is what you get" to be just as 
bad a concept in Text Editors as it is in women. No, the Real Programmer
wants a "you asked for it, you got it" text editor -- complicated, 
cryptic, powerful, unforgiving, dangerous.
