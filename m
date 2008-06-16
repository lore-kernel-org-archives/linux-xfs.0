Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 15 Jun 2008 18:10:48 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5G1AiDd022583
	for <xfs@oss.sgi.com>; Sun, 15 Jun 2008 18:10:45 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 246A81B33405
	for <xfs@oss.sgi.com>; Sun, 15 Jun 2008 18:11:40 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id erH60O8DUdzKk7Fb for <xfs@oss.sgi.com>; Sun, 15 Jun 2008 18:11:40 -0700 (PDT)
Message-ID: <4855BDCB.3030103@sandeen.net>
Date: Sun, 15 Jun 2008 20:11:39 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: XFS errors / BUG / panic, with 2.6.25.7-queue (and older 2.6.25.y)
References: <6101e8c40806141241h4a23f7a6ka5366c84130f1291@mail.gmail.com>	 <48547604.9060700@sandeen.net>	 <6101e8c40806150538h4372dcedob2ab9c45aa01741c@mail.gmail.com>	 <48553C11.2060606@sandeen.net>	 <6101e8c40806150909s4f9b95d2u685c09a0ba3767e3@mail.gmail.com>	 <48553F53.7000208@sandeen.net> <6101e8c40806150914k1226611ej52b20b7bb9ffa9d5@mail.gmail.com>
In-Reply-To: <6101e8c40806150914k1226611ej52b20b7bb9ffa9d5@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Oliver Pinter <oliver.pntr@gmail.com>
Cc: xfs@oss.sgi.com

Oliver Pinter wrote:
> sorry, but I did not learn English, is going a little bit slowly in this manner.

That's, ok, it's just useful to know what you were doing when it
panicked.  I'm sure you speak english better than I speak you native
language ;)

> yeah, under poweroff (init 0) panics the system

Hm, interesting.

> but now it was him that you say the antecedents apt-get update &
> upgrade and git-update-tree (is is a script, that updated 3 git tree
> (linux-2.6, linux-2.6.25.y and stable-queue)) , that is heavy disc i/o
> with much small files

So, you had a lot of IO just before shutdown?

-Eric

> On 6/15/08, Eric Sandeen <sandeen@sandeen.net> wrote:
>> Oliver Pinter wrote:
>>> this is the debian way of the unmounting the root fs:
>> Ok we're slowly getting to useful information.
>>
>> So you were shutting down the system when the panic happened, correct?
>>
>> -Eric
>>
>>
> 
> 
