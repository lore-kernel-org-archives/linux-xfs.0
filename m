Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:48191 "EHLO
        mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751935AbdJXKFU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Oct 2017 06:05:20 -0400
Date: Tue, 24 Oct 2017 12:05:16 +0200
From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH v3 2/8] lockdep: Introduce CROSSRELEASE_STACK_TRACE and
 make it not unwind as default
Message-ID: <20171024100516.f2a2uzknqfum77w2@gmail.com>
References: <1508837889-16932-1-git-send-email-byungchul.park@lge.com>
 <1508837889-16932-3-git-send-email-byungchul.park@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1508837889-16932-3-git-send-email-byungchul.park@lge.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Byungchul Park <byungchul.park@lge.com>
Cc: peterz@infradead.org, axboe@kernel.dk, tglx@linutronix.de, linux-kernel@vger.kernel.org, linux-mm@kvack.org, tj@kernel.org, johannes.berg@intel.com, oleg@redhat.com, amir73il@gmail.com, david@fromorbit.com, darrick.wong@oracle.com, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, hch@infradead.org, idryomov@gmail.com, kernel-team@lge.com


* Byungchul Park <byungchul.park@lge.com> wrote:

> Johan Hovold reported a performance regression by crossrelease like:

Pplease add Reported-by and Analyzed-by tags - you didn't even Cc: Johan!

Thanks,

	Ingo
