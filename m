Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 30 Oct 2008 22:53:38 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9V5rIgi024250
	for <xfs@oss.sgi.com>; Thu, 30 Oct 2008 22:53:18 -0700
Received: from nf-out-0910.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 33C5DB1E3C5
	for <xfs@oss.sgi.com>; Thu, 30 Oct 2008 22:53:17 -0700 (PDT)
Received: from nf-out-0910.google.com (nf-out-0910.google.com [64.233.182.191]) by cuda.sgi.com with ESMTP id DzxMfmKmOlcyK357 for <xfs@oss.sgi.com>; Thu, 30 Oct 2008 22:53:17 -0700 (PDT)
Received: by nf-out-0910.google.com with SMTP id h3so579607nfh.42
        for <xfs@oss.sgi.com>; Thu, 30 Oct 2008 22:53:16 -0700 (PDT)
Message-ID: <f488382f0810302253l6e8b2705u29582f348256a91a@mail.gmail.com>
Date: Thu, 30 Oct 2008 22:53:16 -0700
From: "Steven Noonan" <steven@uplinklabs.net>
Subject: Re: [GIT PULL] XFS update for 2.6.28
In-Reply-To: <alpine.DEB.1.10.0810302201030.3116@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081031045737.ECE0E58AE1E9@chook.melbourne.sgi.com>
	 <alpine.DEB.1.10.0810302201030.3116@asgard.lang.hm>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: david@lang.hm
Cc: Lachlan McIlroy <lachlan@sgi.com>, torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, akpm@linux-foundation.org

On Thu, Oct 30, 2008 at 10:02 PM,  <david@lang.hm> wrote:
> On Fri, 31 Oct 2008, Lachlan McIlroy wrote:
>
>> The following changes since commit
>> 721d5dfe7e516954c501d5e9d0dfab379cf4241a:
>>  Linus Torvalds (1):
>>       Merge branch 'for-linus' of git://neil.brown.name/md
>
> I am a fairly heavy user of XFS and am as eager as anyone to see cleanups
> and improvements, but 102 commits to go into -rc3????
>
> David Lang
>

I'm pretty sure these won't be accepted until 2.6.29's merge window
opens. The merge window for 2.6.28 has closed, and due to the sheer
number of commits, at least -one- is bound to cause a regression.

- Steven
