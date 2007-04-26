Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 26 Apr 2007 10:13:56 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l3QHDqfB021432
	for <xfs@oss.sgi.com>; Thu, 26 Apr 2007 10:13:53 -0700
Message-ID: <4630DDC2.2040705@sandeen.net>
Date: Thu, 26 Apr 2007 12:13:38 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: 2.6.20.3 - possible recursive locking detected - in XFS
References: <200704251116.57737.jesper.juhl@gmail.com>	 <20070425233345.GN48531920@melbourne.sgi.com> <9a8748490704260317u211c244au3c5478ac02c12c43@mail.gmail.com>
In-Reply-To: <9a8748490704260317u211c244au3c5478ac02c12c43@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Jesper Juhl <jesper.juhl@gmail.com>
Cc: David Chinner <dgc@sgi.com>, linux-kernel@vger.kernel.org, xfs-masters@oss.sgi.com, xfs@oss.sgi.com, viro@zeniv.linux.org.uk

Jesper Juhl wrote:
> On 26/04/07, David Chinner <dgc@sgi.com> wrote:

>> Known false positive - XFS doesn't have the annotations needed for
>> this yet; we've got a patch that will probably make it's way into 6.5.22 that
>> should fix most of these issues.

wow... 6.5.22.... do we really have to wait that long? :)

-Eric
