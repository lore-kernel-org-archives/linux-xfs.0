Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 23 Apr 2007 12:51:42 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l3NJpZfB024622
	for <xfs@oss.sgi.com>; Mon, 23 Apr 2007 12:51:37 -0700
Message-ID: <462D0D23.7010803@sandeen.net>
Date: Mon, 23 Apr 2007 14:46:43 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: possible recursive locking detected
References: <Pine.LNX.4.64.0704021914060.3963@sheep.housecafe.de> <20603.194.246.123.250.1177344480.squirrel@derchris.gotdns.org:8080>
In-Reply-To: <20603.194.246.123.250.1177344480.squirrel@derchris.gotdns.org:8080>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christian Kujau <lists@nerdbynature.de>
Cc: xfs@oss.sgi.com

Christian Kujau wrote:
> Hi there,
> 
> On Mon, April 2, 2007 19:18, Christian Kujau wrote:
>> when I enabled a few more debug-options in the kernel (vanilla
>> 2.6.21-rc5), I came across:
>>
>> [ INFO: possible recursive locking detected ]
>> 2.6.21-rc5 #2
> 
> The same happened with -rc7, see below. Can anyone comment if this
> is/could lead to a problem?
>

The consensus seems to be that it is cosmetic.

-Eric
