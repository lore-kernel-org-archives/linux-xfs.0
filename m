Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:34930 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751195AbdCOKlJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Mar 2017 06:41:09 -0400
From: Nikolay Borisov <n.borisov.lkml@gmail.com>
Subject: Request for including dbd5c8c9a288 ("xfs: pass total block res. as
 total xfs_bmapi_write() parameter") into stable
Message-ID: <153397e1-ba41-20b3-455e-d622c234bc3a@gmail.com>
Date: Wed, 15 Mar 2017 12:41:02 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: stable@vger.kernel.org
Cc: darrick.wong@oracle.com, linux-xfs@vger.kernel.org, david@fromorbit.com

Hello,

I'd like to request the commit from the subject to be included into
stable kernels, starting with 3.12. Without generic/299 would deadlock
almost always, whereas with the commit applied I can get it to run 20
consecutive times without a hitch.


Regards,
Nikolay
