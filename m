Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:54274 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935809AbdKPUFN (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 16 Nov 2017 15:05:13 -0500
Received: from Liberator-5.sandeen.net (Liberator-5.sandeen.net [10.0.0.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 9D3B455306F
        for <linux-xfs@vger.kernel.org>; Thu, 16 Nov 2017 14:05:02 -0600 (CST)
From: Eric Sandeen <sandeen@sandeen.net>
Subject: Note: xfsprogs libxfs-4.15-sync branch has been rebased
Message-ID: <93ae6ca4-41f8-b95f-b738-e8ec2f78dee5@sandeen.net>
Date: Thu, 16 Nov 2017 14:05:12 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

FYI, I've rebased the libxfs-4.15-sync branch to fix the
mknod issue Darrick spotted, fix some type problems, and
annotate commits with my modifications that are not in the
original kernel commits.

Thanks,
-Eric
