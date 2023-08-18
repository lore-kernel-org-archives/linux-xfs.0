Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 590F4C05052
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Aug 2023 09:02:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358954AbjHRJCW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 18 Aug 2023 05:02:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358890AbjHRJBy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 18 Aug 2023 05:01:54 -0400
X-Greylist: delayed 1506 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 18 Aug 2023 02:01:31 PDT
Received: from mail.leachkin.pl (mail.leachkin.pl [217.61.97.203])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDAF83C28
        for <linux-xfs@vger.kernel.org>; Fri, 18 Aug 2023 02:01:31 -0700 (PDT)
Received: by mail.leachkin.pl (Postfix, from userid 1001)
        id 97C3282F94; Fri, 18 Aug 2023 09:15:55 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=leachkin.pl; s=mail;
        t=1692346555; bh=elHzctRz/z3PfTIhGYJKd0TeBTmca98Y+JNgX4gfsPI=;
        h=Date:From:To:Subject:From;
        b=HyYjbpyeLSzJS+dftcmMr4IwDart8x679hd5GdCOD0HWyhwvhOacfaQRxkm5penEw
         fyfS1JgNFuE0IiP/8ymCR3cyoGT5G7r5kHcsqEvQLzA1f7QjWGl3555mvynjHr+s/z
         JeYMeCsSjZ7XXaTUugFRricqSkWfY3RwxoXXckw6E4AztzXHlzU28AbohMdVYtjjTc
         z8odExRxPovp1U1lQ9/TC80yAS9tYQDuBfXtsfJ1+q4byMHKvxPXSmD62o7W+jkNO7
         0fcd2FP+mxKz9HSeq99x8SqlGSuCviRKQNrGUyOBDVr8V+JcEnXnnrrMY1KRqytcFw
         EYnc+4I3qC4Fw==
Received: by mail.leachkin.pl for <linux-xfs@vger.kernel.org>; Fri, 18 Aug 2023 08:15:51 GMT
Message-ID: <20230818074501-0.1.4u.ctp2.0.fu25nornw7@leachkin.pl>
Date:   Fri, 18 Aug 2023 08:15:51 GMT
From:   "Jakub Lemczak" <jakub.lemczak@leachkin.pl>
To:     <linux-xfs@vger.kernel.org>
Subject: =?UTF-8?Q?Pytanie_o_samoch=C3=B3d?=
X-Mailer: mail.leachkin.pl
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Dzie=C5=84 dobry,

Czy interesuje Pa=C5=84stwa rozwi=C4=85zanie umo=C5=BCliwiaj=C4=85ce moni=
torowanie samochod=C3=B3w firmowych oraz optymalizacj=C4=99 koszt=C3=B3w =
ich utrzymania?=20


Pozdrawiam,
Jakub Lemczak
