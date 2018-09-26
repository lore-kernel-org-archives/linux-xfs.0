Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:36908 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726107AbeI0DiZ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 26 Sep 2018 23:38:25 -0400
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 05FCD2B37
        for <linux-xfs@vger.kernel.org>; Wed, 26 Sep 2018 16:22:42 -0500 (CDT)
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [PATCH 0/2] xfsprogs: env var stuff
Message-ID: <05122b65-0a26-c36f-1efb-78591497ed90@sandeen.net>
Date: Wed, 26 Sep 2018 16:23:31 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

We've started using env vars for a few things; clean up one nit
and document them.
