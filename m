Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from out30-43.freemail.mail.aliyun.com ([115.124.30.43]:48673 "EHLO
        out30-43.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726375AbfF0MLC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Jun 2019 08:11:02 -0400
From: Alvin Zheng <Alvin@linux.alibaba.com>
Subject: [backport request][stable] xfs: xfstests generic/538 failed on xfs
Message-ID: <a665a93a-0bf8-aedb-2ba3-d4b2fb672970@linux.alibaba.com>
Date: Thu, 27 Jun 2019 20:10:56 +0800
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: gregkh <gregkh@linuxfoundation.org>, linux-xfs <linux-xfs@vger.kernel.org>, bfoster@redhat.com
Cc: "joseph.qi" <joseph.qi@linux.alibaba.com>, caspar <caspar@linux.alibaba.com>

Hi,

     I  was using kernel v4.19.y and found that it cannot pass the 
generic/538 due to data corruption. I notice that upstream has fix this 
issue with commit 2032a8a27b5cc0f578d37fa16fa2494b80a0d00a. Will v4.19.y 
backport this patch?

Best regards,

Alvin
