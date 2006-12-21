Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 21 Dec 2006 08:38:27 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kBLGcMqw012594
	for <xfs@oss.sgi.com>; Thu, 21 Dec 2006 08:38:23 -0800
Message-ID: <458AB83F.4050701@sandeen.net>
Date: Thu, 21 Dec 2006 10:37:19 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] Return failure error if something fails in xfs_growfs
References: <200612210609.RAA24334@larry.melbourne.sgi.com>
In-Reply-To: <200612210609.RAA24334@larry.melbourne.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@melbourne.sgi.com>
Cc: xfs-dev@corp.sgi.com, xfs@oss.sgi.com

Barry Naujok wrote:
> A very simple patch that return error rather than success if something
> fails in xfs_growfs.
> 
> Barry.

Try as I might to follow the grand linux tradition of finding some minor
stylistic point to complain about (whitespace, formatting, choice of
variable names, etc) I could not.  So, looks good to me.  :-)

-Eric
