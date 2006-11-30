Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 30 Nov 2006 13:17:20 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kAULHCaG013040
	for <xfs@oss.sgi.com>; Thu, 30 Nov 2006 13:17:14 -0800
Message-ID: <456F4A25.80709@sandeen.net>
Date: Thu, 30 Nov 2006 15:16:21 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: TAKE 957159 - Reduce XFS 4k stack kernel issues
References: <20061130080359.E3F7C58FF58B@chook.melbourne.sgi.com>
In-Reply-To: <20061130080359.E3F7C58FF58B@chook.melbourne.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs@oss.sgi.com

David, did this add any new static declarations, or just get the
existing ones into shape?

IOW, I think I should rework my make-more-things-static patch?

-Eric
