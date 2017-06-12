Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44780 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752182AbdFLHYT (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 12 Jun 2017 03:24:19 -0400
From: Nikolay Borisov <nborisov@suse.com>
Subject: Request for inclusion of b54554ac5afa ("Make __xfs_xattr_put_listen
 preperly report errors.")
Message-ID: <f29b6c4b-3f22-21b1-a02a-5331d22ee485@suse.com>
Date: Mon, 12 Jun 2017 10:24:16 +0300
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>, darrick.wong@oracle.com, asavkov@redhat.com

Hello,

I'd like to request the inclusion of the aforementioned patch. It is
needed as an addition to 2a6fba6d2311 ("xfs: only return -errno or
success from attr ->put_listent") which was already included in 4.4.71.

Regards,
Nikolay
