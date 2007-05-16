Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 16 May 2007 10:35:41 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l4GHZafB030708
	for <linux-xfs@oss.sgi.com>; Wed, 16 May 2007 10:35:37 -0700
Message-ID: <464B40E6.1060507@sandeen.net>
Date: Wed, 16 May 2007 12:35:34 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: possible recursive locking detected
References: <f2f5n0$1ja$1@sea.gmane.org>
In-Reply-To: <f2f5n0$1ja$1@sea.gmane.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Bernd Schubert <bschubert@q-leap.de>
Cc: linux-xfs@oss.sgi.com

Bernd Schubert wrote:
> with 2.6.20 and almost all debugging options I get this:
> 
> [  293.840172] =============================================
> [  293.847880] [ INFO: possible recursive locking detected ]
> [  293.853862] 2.6.20.3-debug #11
> [  293.857288] ---------------------------------------------

Many of these have been addressed with this patch:

http://oss.sgi.com/archives/xfs/2007-04/msg00177.html

-Eric
