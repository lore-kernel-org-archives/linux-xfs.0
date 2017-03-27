Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42042 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751962AbdC0U0K (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 27 Mar 2017 16:26:10 -0400
From: David Howells <dhowells@redhat.com>
In-Reply-To: <05b4710f-8459-6386-244b-9df2db8398f9@sandeen.net>
References: <05b4710f-8459-6386-244b-9df2db8398f9@sandeen.net> <7a090a8e-7204-1b9b-8b31-e7a061b39f87@sandeen.net>
Subject: Re: [PATCH 1/2 V2] xfs_io: move stat functions to new file
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <6206.1490646367.1@warthog.procyon.org.uk>
Date: Mon, 27 Mar 2017 21:26:07 +0100
Message-ID: <6207.1490646367@warthog.procyon.org.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: dhowells@redhat.com, linux-xfs <linux-xfs@vger.kernel.org>, Andreas Dilger <adilger@dilger.ca>, Christoph Hellwig <hch@infradead.org>, fsdevel <linux-fsdevel@vger.kernel.org>

Eric Sandeen <sandeen@sandeen.net> wrote:

> diff --git a/io/Makefile b/io/Makefile

What do I apply this to?  I don't see any directory or file called "io" in
xfstests-dev/master.

David
