Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:33490 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751162AbdFCFXS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 3 Jun 2017 01:23:18 -0400
Received: by mail-pf0-f195.google.com with SMTP id f27so14725863pfe.0
        for <linux-xfs@vger.kernel.org>; Fri, 02 Jun 2017 22:23:17 -0700 (PDT)
Date: Fri, 2 Jun 2017 22:23:15 -0700
From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: [PATCH] xfs: avoid -Wint-in-bool-context warning in
 xfs_bmap_util.c
Message-ID: <20170603052315.GA3399@zzz>
References: <20170603042107.17469-1-ebiggers3@gmail.com>
 <20170603045041.GF5636@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170603045041.GF5636@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, Eric Biggers <ebiggers@google.com>

On Fri, Jun 02, 2017 at 09:50:41PM -0700, Darrick J. Wong wrote:
> 
> Arnd Bergmann already sent the exact same patch[1] for 4.13, but, er,
> thanks for spotting this! :)
> 
> --D
> 
> [1] https://marc.info/?l=linux-xfs&m=149498134833721&w=2
> 

Oh, okay.  I didn't see anything in
git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git#for-next; I guess it hasn't
been pushed out yet.

Eric
