Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-ed1-f41.google.com ([209.85.208.41]:42085 "EHLO
        mail-ed1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726570AbeLRVWL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Dec 2018 16:22:11 -0500
Received: by mail-ed1-f41.google.com with SMTP id y20so8989339edw.9
        for <linux-xfs@vger.kernel.org>; Tue, 18 Dec 2018 13:22:09 -0800 (PST)
Received: from teal.hq.k1024.org (77-59-128-99.dclient.hispeed.ch. [77.59.128.99])
        by smtp.gmail.com with ESMTPSA id z6-v6sm2398510ejq.63.2018.12.18.13.22.08
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 18 Dec 2018 13:22:08 -0800 (PST)
Date: Tue, 18 Dec 2018 22:22:07 +0100
From: Iustin Pop <iustin@k1024.org>
Subject: reflink status?
Message-ID: <20181218212207.GA27985@teal.hq.k1024.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Apologies if this information is available somewhere, but a quick scan
at the list archives failed to clarify things for me.

How production ready is the reflink/clone code? I saw a patch series in
October for 4.19rc-something with many fixes ("fixes for serious
clone/dedupe problems"), so I guess pre-4.19 kernels are not quite
recommended yet? Is 4.19 OK for it?

Thanks in advance for any hints. Pointers to where I can keep up to date
with this besides the mailing list are also welcome.

regards,
iustin
