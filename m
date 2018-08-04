Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from www262.sakura.ne.jp ([202.181.97.72]:36527 "EHLO
        www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726744AbeHDMSs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 4 Aug 2018 08:18:48 -0400
Subject: Re: [4.18 rc7] possible circular locking dependency detected
References: <CABXGCsOOBH6SW6=Z6Rw21cg_CKF_GZW7yP1v+L8pDK3MNykShw@mail.gmail.com>
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Message-ID: <cd557d30-8306-52de-09af-28e4d847219a@I-love.SAKURA.ne.jp>
Date: Sat, 4 Aug 2018 19:18:26 +0900
MIME-Version: 1.0
In-Reply-To: <CABXGCsOOBH6SW6=Z6Rw21cg_CKF_GZW7yP1v+L8pDK3MNykShw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Cc: linux-xfs@vger.kernel.org, linux-mm@kvack.org

On 2018/08/04 17:18, Mikhail Gavrilov wrote:
> Hi guys I see this warning already several times when use latest 4.18 kernel.
> May be this is well know issue, I don't know.
> Hope this can fixed soon.

https://marc.info/?l=linux-xfs&m=152954339303385

And since I can't afford fixing lockdep, we can't fix this soon...
