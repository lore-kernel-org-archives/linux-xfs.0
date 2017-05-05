Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mr002msb.fastweb.it ([85.18.95.86]:46922 "EHLO
        mr002msb.fastweb.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751085AbdEEK3t (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 May 2017 06:29:49 -0400
Received: from ceres.assyoma.it (93.63.55.57) by mr002msb.fastweb.it (8.5.140.05)
        id 58E21DDC01538CF7 for linux-xfs@vger.kernel.org; Fri, 5 May 2017 12:29:47 +0200
From: Gionatan Danti <g.danti@assyoma.it>
Subject: XFS and multiple mounts protection (aka preventing multiple mounts)
Message-ID: <3cf2f8cd-d18f-2a65-c540-5527a366d2fb@assyoma.it>
Date: Fri, 5 May 2017 12:29:46 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: g.danti@assyoma.it

Hi all,
I have a question about multiple mounts protection in XFS.

On the iSCSI list, discussing how to avoid accidental multiple mounts, I 
received the following advise: "Use XFS. XFS won't let you mount it 
several time on different machines without various "force" options."

I just tried mounting an exported iSCSI disk formatted with XFS and I 
*can* mount it concurrently on two different Linux boxes (both CentOS 
7.3 x86-64).

I am missing something?
Thanks.

-- 
Danti Gionatan
Supporto Tecnico
Assyoma S.r.l. - www.assyoma.it
email: g.danti@assyoma.it - info@assyoma.it
GPG public key ID: FF5F32A8
