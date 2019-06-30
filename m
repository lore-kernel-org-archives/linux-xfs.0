Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail02.iobjects.de ([188.40.134.68]:54982 "EHLO
        mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726498AbfF3Lg7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 30 Jun 2019 07:36:59 -0400
Received: from tux.wizards.de (pD9EBFA35.dip0.t-ipconnect.de [217.235.250.53])
        by mail02.iobjects.de (Postfix) with ESMTPSA id A8D3C4160A8C
        for <linux-xfs@vger.kernel.org>; Sun, 30 Jun 2019 13:28:09 +0200 (CEST)
Received: from [192.168.100.223] (ragnarok.applied-asynchrony.com [192.168.100.223])
        by tux.wizards.de (Postfix) with ESMTP id 1DBA3F015F1
        for <linux-xfs@vger.kernel.org>; Sun, 30 Jun 2019 13:28:09 +0200 (CEST)
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Subject: Include 'xfs: speed up large directory modifications' in 5.3?
Message-ID: <56158aa8-c07a-f90f-a166-b2eeb226bb4a@applied-asynchrony.com>
Date: Sun, 30 Jun 2019 13:28:09 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

Hi,

I have been running with Dave's series for faster directory inserts since
forever without any issues, and the last revision [1] still applies cleanly
to current5.2-rc (not sure about xfs-next though).
Any chance this can be included in 5.3? IMHO it would be a shame if this
fell through the cracks again.

Thanks,
Holger

[1] https://patchwork.kernel.org/project/xfs/list/?series=34713
